#!/bin/bash
set -e

CONFIG_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$CONFIG_DIR/.backup"
DRY_RUN=false
CLAUDE_HOME="$HOME/.claude"
CODEX_HOME="$HOME/.codex"
SKILL_DIRS=("$CODEX_HOME/skills" "$CLAUDE_HOME/skills")

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

is_repo_symlink() {
    local path="$1"
    if [ -L "$path" ] && [[ "$(readlink "$path")" == "$CONFIG_DIR"* ]]; then
        return 0
    fi
    return 1
}

find_skill_source() {
    local name="$1"
    local path=""

    for dir in "${SKILL_DIRS[@]}"; do
        path="$dir/$name"
        if [ -d "$path" ] && ! is_repo_symlink "$path"; then
            echo "$path"
            return 0
        fi
    done

    return 1
}

# Capitalize first letter (portable alternative to ${var^})
capitalize() {
    local str="$1"
    local first="${str:0:1}"
    local rest="${str:1}"
    printf '%s%s' "$(echo "$first" | tr '[:lower:]' '[:upper:]')" "$rest"
}

# Create backup with timestamp
create_backup() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_path="$BACKUP_DIR/$timestamp"
    mkdir -p "$backup_path"
    echo "$backup_path"
}

# Backup a file or directory
backup_item() {
    local src="$1"
    local backup_path="$2"
    local relative_path="${src#$HOME/}"
    local dest="$backup_path/$relative_path"

    mkdir -p "$(dirname "$dest")"
    if [ -L "$src" ]; then
        echo "$(readlink "$src")" > "$dest.symlink"
    elif [ -d "$src" ]; then
        cp -r "$src" "$dest"
    else
        cp "$src" "$dest"
    fi
}

# Write manifest
write_manifest() {
    local backup_path="$1"
    local operation="$2"
    shift 2
    local items=("$@")

    cat > "$backup_path/manifest.json" << EOF
{
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "operation": "$operation",
    "items": [$(printf '"%s",' "${items[@]}" | sed 's/,$//')],
    "user": "$USER",
    "hostname": "$(hostname)"
}
EOF
}

# Validate skill SKILL.md frontmatter
validate_skill() {
    local skill_path="$1"
    local skill_name=$(basename "$skill_path")
    local skill_md="$skill_path/SKILL.md"
    local errors=()

    if [ ! -f "$skill_md" ]; then
        errors+=("Missing SKILL.md")
    else
        # Check that file has both --- delimiters for valid frontmatter
        local delimiter_count
        delimiter_count=$(grep -c "^---$" "$skill_md" 2>/dev/null) || delimiter_count=0

        if [ "$delimiter_count" -lt 2 ]; then
            errors+=("Missing frontmatter (--- markers)")
        else
            # Extract frontmatter (between --- markers)
            local frontmatter=$(sed -n '/^---$/,/^---$/p' "$skill_md" | sed '1d;$d')

            if [ -z "$frontmatter" ]; then
                errors+=("Empty frontmatter")
            else
                # Check for name field
                if ! echo "$frontmatter" | grep -q "^name:"; then
                    errors+=("Missing 'name' in frontmatter")
                fi

                # Check for description field
                if ! echo "$frontmatter" | grep -q "^description:"; then
                    errors+=("Missing 'description' in frontmatter")
                fi
            fi
        fi
    fi

    if [ ${#errors[@]} -gt 0 ]; then
        echo -e "${YELLOW}⚠${RESET} $skill_name: ${errors[*]}"
        return 1
    fi
    return 0
}

# Show status for a directory-based item (skills)
show_dir_status() {
    local local_dir="$1"
    local repo_dir="$2"

    for item in "$local_dir"/*/; do
        [ -d "$item" ] || continue
        item_name=$(basename "$item")
        item_path="$local_dir/$item_name"

        if [ -L "$item_path" ]; then
            target=$(readlink "$item_path")
            if [[ "$target" == "$CONFIG_DIR"* ]]; then
                echo -e "  ${GREEN}✓${RESET} $item_name (synced)"
            else
                echo -e "  ${BLUE}→${RESET} $item_name (symlink to elsewhere)"
            fi
        else
            if [ -d "$repo_dir/$item_name" ]; then
                echo -e "  ${YELLOW}⚠${RESET} $item_name (exists in both - local copy)"
            else
                echo -e "  ${RESET}○${RESET} $item_name (local only)"
            fi
        fi
    done
}

# Show status for a file-based item (agents, rules)
show_file_status() {
    local type="$1"
    local local_dir="$CLAUDE_HOME/$type"
    local repo_dir="$CONFIG_DIR/$type"

    for item in "$local_dir"/*.md; do
        [ -f "$item" ] || continue
        item_name=$(basename "$item")
        item_path="$local_dir/$item_name"

        if [ -L "$item_path" ]; then
            target=$(readlink "$item_path")
            if [[ "$target" == "$CONFIG_DIR"* ]]; then
                echo -e "  ${GREEN}✓${RESET} $item_name (synced)"
            else
                echo -e "  ${BLUE}→${RESET} $item_name (symlink to elsewhere)"
            fi
        else
            if [ -f "$repo_dir/$item_name" ]; then
                echo -e "  ${YELLOW}⚠${RESET} $item_name (exists in both - local copy)"
            else
                echo -e "  ${RESET}○${RESET} $item_name (local only)"
            fi
        fi
    done
}

show_status() {
    echo -e "${BOLD}Agent Config Sync Status${RESET}"
    echo "========================="
    echo ""

    echo -e "${BOLD}Skills (~/.claude):${RESET}"
    if [ -d "$CLAUDE_HOME/skills" ] && [ -n "$(ls -A "$CLAUDE_HOME/skills" 2>/dev/null)" ]; then
        show_dir_status "$CLAUDE_HOME/skills" "$CONFIG_DIR/skills"
    else
        echo "  (none)"
    fi
    echo ""

    echo -e "${BOLD}Skills (~/.codex):${RESET}"
    if [ -d "$CODEX_HOME/skills" ] && [ -n "$(ls -A "$CODEX_HOME/skills" 2>/dev/null)" ]; then
        show_dir_status "$CODEX_HOME/skills" "$CONFIG_DIR/skills"
    else
        echo "  (none)"
    fi
    echo ""

    echo -e "${BOLD}Agents:${RESET}"
    if [ -d "$CLAUDE_HOME/agents" ] && ls "$CLAUDE_HOME/agents"/*.md &>/dev/null; then
        show_file_status "agents"
    else
        echo "  (none)"
    fi
    echo ""

    echo -e "${BOLD}Rules:${RESET}"
    if [ -d "$CLAUDE_HOME/rules" ] && ls "$CLAUDE_HOME/rules"/*.md &>/dev/null; then
        show_file_status "rules"
    else
        echo "  (none)"
    fi
    echo ""

    echo "Legend: ✓ synced | ○ local only | ⚠ conflict | → external"
    echo ""
    echo "Usage:"
    echo "  ./sync.sh add <type> <name>     Add a local item to repo"
    echo "  ./sync.sh remove <type> <name>  Remove an item from repo (keeps local)"
    echo "  ./sync.sh pull                  Pull latest and reinstall"
    echo "  ./sync.sh push                  Commit and push changes"
    echo "  ./sync.sh undo                  Restore from last backup"
    echo "  ./sync.sh validate              Validate all skills"
    echo "  ./sync.sh backups               List available backups"
    echo ""
    echo "Options:"
    echo "  -n, --dry-run                   Show what would be done"
    echo ""
    echo "Types: skill, agent, rule"
}

add_skill() {
    local name="$1"
    local src
    local dest="$CONFIG_DIR/skills/$name"
    local skill_dir=""
    local found_any=false
    local all_synced=true

    for skill_dir in "${SKILL_DIRS[@]}"; do
        if [ -d "$skill_dir/$name" ]; then
            found_any=true
            if ! is_repo_symlink "$skill_dir/$name"; then
                all_synced=false
            fi
        else
            all_synced=false
        fi
    done

    if ! $found_any; then
        echo "Error: Skill '$name' not found in ~/.claude/skills or ~/.codex/skills"
        exit 1
    fi

    if $all_synced; then
        echo "Error: '$name' is already synced"
        exit 1
    fi

    src="$(find_skill_source "$name")" || true
    if [ -z "$src" ]; then
        echo "Error: '$name' is already synced"
        exit 1
    fi

    if [ -e "$dest" ]; then
        echo "Error: Skill '$name' already exists in repo at $dest"
        exit 1
    fi

    # Validate skill before adding
    if ! validate_skill "$src"; then
        echo ""
        read -p "Add anyway? [y/N]: " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            echo "Aborted."
            exit 1
        fi
    fi

    if $DRY_RUN; then
        echo -e "${BLUE}[dry-run]${RESET} Would copy $src to $dest"
        for skill_dir in "${SKILL_DIRS[@]}"; do
            echo -e "${BLUE}[dry-run]${RESET} Would create symlink $skill_dir/$name -> $dest"
        done
        return
    fi

    echo "Adding skill '$name' to repo..."

    # Create backup before modifying
    local backup_path=$(create_backup)
    backup_item "$src" "$backup_path"
    write_manifest "$backup_path" "add-skill" "$name"

    mkdir -p "$CONFIG_DIR/skills"
    cp -r "$src" "$dest"

    for skill_dir in "${SKILL_DIRS[@]}"; do
        local target="$skill_dir/$name"
        mkdir -p "$skill_dir"
        if [ -e "$target" ] || [ -L "$target" ]; then
            backup_item "$target" "$backup_path"
            rm -rf "$target"
        fi
        ln -s "$dest" "$target"
    done

    echo -e "${GREEN}✓${RESET} Skill '$name' added and symlinked in ~/.claude and ~/.codex"
    echo -e "${BLUE}Backup saved:${RESET} $backup_path"
    echo "  Run: ./sync.sh push"
}

add_file() {
    local type="$1"
    local name="$2"
    local src="$CLAUDE_HOME/$type/$name.md"
    local dest="$CONFIG_DIR/$type/$name.md"

    if [ ! -f "$src" ]; then
        echo "Error: ${type%s} not found at $src"
        exit 1
    fi

    if [ -L "$src" ] && [[ "$(readlink "$src")" == "$CONFIG_DIR"* ]]; then
        echo "Error: '$name' is already synced"
        exit 1
    fi

    if $DRY_RUN; then
        echo -e "${BLUE}[dry-run]${RESET} Would copy $src to $dest"
        echo -e "${BLUE}[dry-run]${RESET} Would create symlink $src -> $dest"
        return
    fi

    echo "Adding ${type%s} '$name' to repo..."

    # Create backup before modifying
    local backup_path=$(create_backup)
    backup_item "$src" "$backup_path"
    write_manifest "$backup_path" "add-${type%s}" "$name"

    mkdir -p "$CONFIG_DIR/$type"
    cp "$src" "$dest"
    rm "$src"
    ln -s "$dest" "$src"

    echo -e "${GREEN}✓${RESET} $(capitalize "${type%s}") '$name' added and symlinked"
    echo -e "${BLUE}Backup saved:${RESET} $backup_path"
    echo "  Run: ./sync.sh push"
}

remove_skill() {
    local name="$1"
    local dest="$CONFIG_DIR/skills/$name"

    if [ ! -d "$dest" ]; then
        echo "Error: Skill '$name' not in repo"
        exit 1
    fi

    if $DRY_RUN; then
        local skill_dir=""
        for skill_dir in "${SKILL_DIRS[@]}"; do
            echo -e "${BLUE}[dry-run]${RESET} Would remove symlink at $skill_dir/$name"
            echo -e "${BLUE}[dry-run]${RESET} Would copy $dest to $skill_dir/$name"
        done
        echo -e "${BLUE}[dry-run]${RESET} Would delete $dest from repo"
        return
    fi

    echo "Removing skill '$name' from repo..."

    # Create backup
    local backup_path=$(create_backup)
    backup_item "$dest" "$backup_path"
    local skill_dir=""
    for skill_dir in "${SKILL_DIRS[@]}"; do
        local target="$skill_dir/$name"
        if [ -e "$target" ] || [ -L "$target" ]; then
            backup_item "$target" "$backup_path"
        fi
    done
    write_manifest "$backup_path" "remove-skill" "$name"

    for skill_dir in "${SKILL_DIRS[@]}"; do
        local target="$skill_dir/$name"
        mkdir -p "$skill_dir"
        if is_repo_symlink "$target"; then
            rm "$target"
            cp -r "$dest" "$target"
        fi
    done

    rm -rf "$dest"

    echo -e "${GREEN}✓${RESET} Skill '$name' removed from repo (kept local in ~/.claude and ~/.codex)"
    echo -e "${BLUE}Backup saved:${RESET} $backup_path"
    echo "  Run: ./sync.sh push"
}

remove_file() {
    local type="$1"
    local name="$2"
    local src="$CLAUDE_HOME/$type/$name.md"
    local dest="$CONFIG_DIR/$type/$name.md"

    if [ ! -f "$dest" ]; then
        echo "Error: ${type%s} '$name' not in repo"
        exit 1
    fi

    if $DRY_RUN; then
        echo -e "${BLUE}[dry-run]${RESET} Would remove symlink at $src"
        echo -e "${BLUE}[dry-run]${RESET} Would copy $dest to $src"
        echo -e "${BLUE}[dry-run]${RESET} Would delete $dest from repo"
        return
    fi

    echo "Removing ${type%s} '$name' from repo..."

    # Create backup
    local backup_path=$(create_backup)
    backup_item "$dest" "$backup_path"
    if [ -L "$src" ]; then
        backup_item "$src" "$backup_path"
    fi
    write_manifest "$backup_path" "remove-${type%s}" "$name"

    if [ -L "$src" ] && [[ "$(readlink "$src")" == "$CONFIG_DIR"* ]]; then
        rm "$src"
        cp "$dest" "$src"
    fi

    rm "$dest"

    echo -e "${GREEN}✓${RESET} $(capitalize "${type%s}") '$name' removed from repo (kept as local)"
    echo -e "${BLUE}Backup saved:${RESET} $backup_path"
    echo "  Run: ./sync.sh push"
}

pull_changes() {
    if $DRY_RUN; then
        echo -e "${BLUE}[dry-run]${RESET} Would run: git pull"
        echo -e "${BLUE}[dry-run]${RESET} Would run: ./install.sh"
        return
    fi

    echo "Pulling latest changes..."
    cd "$CONFIG_DIR"
    git pull
    echo ""
    echo "Re-running install..."
    ./install.sh
}

push_changes() {
    cd "$CONFIG_DIR"

    if [ -z "$(git status --porcelain)" ]; then
        echo "Nothing to push - working tree clean"
        exit 0
    fi

    if $DRY_RUN; then
        echo -e "${BLUE}[dry-run]${RESET} Would commit and push:"
        git status --short
        return
    fi

    echo "Changes to push:"
    git status --short
    echo ""

    read -p "Commit message (or Ctrl+C to cancel): " msg
    git add -A
    git commit -m "$msg"
    git push

    echo -e "${GREEN}✓${RESET} Pushed to remote"
}

list_backups() {
    echo -e "${BOLD}Available Backups${RESET}"
    echo "================="
    echo ""

    if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
        echo "No backups found."
        return
    fi

    for backup in "$BACKUP_DIR"/*/; do
        [ -d "$backup" ] || continue
        local name=$(basename "$backup")
        local manifest="$backup/manifest.json"

        if [ -f "$manifest" ]; then
            local operation=$(grep -o '"operation": *"[^"]*"' "$manifest" | cut -d'"' -f4)
            local timestamp=$(grep -o '"timestamp": *"[^"]*"' "$manifest" | cut -d'"' -f4)
            echo -e "  ${GREEN}$name${RESET}"
            echo "    Operation: $operation"
            echo "    Time: $timestamp"
        else
            echo -e "  ${YELLOW}$name${RESET} (no manifest)"
        fi
    done
    echo ""
}

undo_last() {
    if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
        echo "No backups found."
        exit 1
    fi

    # Find the most recent backup
    local latest=$(ls -1t "$BACKUP_DIR" | head -1)
    local backup_path="$BACKUP_DIR/$latest"
    local manifest="$backup_path/manifest.json"

    if [ ! -f "$manifest" ]; then
        echo "Error: No manifest found in $backup_path"
        exit 1
    fi

    local operation=$(grep -o '"operation": *"[^"]*"' "$manifest" | cut -d'"' -f4)
    local timestamp=$(grep -o '"timestamp": *"[^"]*"' "$manifest" | cut -d'"' -f4)

    echo -e "${BOLD}Last backup:${RESET} $latest"
    echo "  Operation: $operation"
    echo "  Time: $timestamp"
    echo ""
    echo "Contents:"
    ls -la "$backup_path" | tail -n +2 | sed 's/^/  /'
    echo ""

    if $DRY_RUN; then
        echo -e "${BLUE}[dry-run]${RESET} Would restore files from $backup_path"
        return
    fi

    read -p "Restore from this backup? [y/N]: " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi

    echo ""
    echo "Restoring..."

    # Restore each item in backup roots
    local backup_root=""
    for backup_root in "$backup_path/.claude" "$backup_path/.codex"; do
        [ -d "$backup_root" ] || continue
        for item in "$backup_root"/*; do
            [ -e "$item" ] || continue
            local item_name=$(basename "$item")
            local root_name=$(basename "$backup_root")
            local dest="$HOME/$root_name/$item_name"

            if [[ "$item" == *.symlink ]]; then
                # Restore symlink
                local target=$(cat "$item")
                local real_dest="${dest%.symlink}"
                rm -rf "$real_dest"
                ln -s "$target" "$real_dest"
                echo -e "${GREEN}✓${RESET} Restored symlink: $real_dest -> $target"
            elif [ -d "$item" ]; then
                rm -rf "$dest"
                cp -r "$item" "$dest"
                echo -e "${GREEN}✓${RESET} Restored directory: $dest"
            else
                rm -f "$dest"
                cp "$item" "$dest"
                echo -e "${GREEN}✓${RESET} Restored file: $dest"
            fi
        done
    done

    # Mark backup as used by renaming
    mv "$backup_path" "$backup_path.restored"

    echo ""
    echo -e "${GREEN}Done!${RESET} Backup restored and marked as used."
    echo "The backup is now at: $backup_path.restored"
}

validate_all_skills() {
    echo -e "${BOLD}Validating Skills${RESET}"
    echo "================="
    echo ""

    local has_errors=false
    local checked=0

    # Check repo skills
    if [ -d "$CONFIG_DIR/skills" ]; then
        for skill in "$CONFIG_DIR/skills"/*/; do
            [ -d "$skill" ] || continue
            ((checked++)) || true
            if ! validate_skill "$skill"; then
                has_errors=true
            else
                echo -e "${GREEN}✓${RESET} $(basename "$skill")"
            fi
        done
    fi

    # Check local-only skills in both Claude and Codex directories
    local skill_dir=""
    for skill_dir in "$CLAUDE_HOME/skills" "$CODEX_HOME/skills"; do
        [ -d "$skill_dir" ] || continue
        for skill in "$skill_dir"/*/; do
            [ -d "$skill" ] || continue
            local skill_path="${skill%/}"
            # Skip if it's a symlink to our repo (already checked)
            if is_repo_symlink "$skill_path"; then
                continue
            fi
            ((checked++)) || true
            if ! validate_skill "$skill_path"; then
                has_errors=true
            else
                echo -e "${GREEN}✓${RESET} $(basename "$skill_path") (local)"
            fi
        done
    done

    echo ""
    if [ $checked -eq 0 ]; then
        echo "No skills found to validate."
    elif $has_errors; then
        echo -e "${YELLOW}Some skills have issues.${RESET}"
        echo "Skills should have a SKILL.md with frontmatter containing 'name' and 'description'."
        exit 1
    else
        echo -e "${GREEN}All $checked skills valid.${RESET}"
    fi
}

# Main
# Check for global --dry-run before command
args=("$@")
for i in "${!args[@]}"; do
    if [[ "${args[$i]}" == "-n" || "${args[$i]}" == "--dry-run" ]]; then
        DRY_RUN=true
        unset 'args[$i]'
    fi
done
set -- "${args[@]}"

case "${1:-}" in
    add)
        type="${2:-}"
        name="${3:-}"
        [ -z "$type" ] || [ -z "$name" ] && { echo "Usage: ./sync.sh add <type> <name>"; echo "Types: skill, agent, rule"; exit 1; }
        case "$type" in
            skill)  add_skill "$name" ;;
            agent)  add_file "agents" "$name" ;;
            rule)   add_file "rules" "$name" ;;
            *)      echo "Unknown type: $type (use: skill, agent, rule)"; exit 1 ;;
        esac
        ;;
    remove)
        type="${2:-}"
        name="${3:-}"
        [ -z "$type" ] || [ -z "$name" ] && { echo "Usage: ./sync.sh remove <type> <name>"; echo "Types: skill, agent, rule"; exit 1; }
        case "$type" in
            skill)  remove_skill "$name" ;;
            agent)  remove_file "agents" "$name" ;;
            rule)   remove_file "rules" "$name" ;;
            *)      echo "Unknown type: $type (use: skill, agent, rule)"; exit 1 ;;
        esac
        ;;
    pull)
        pull_changes
        ;;
    push)
        push_changes
        ;;
    undo)
        undo_last
        ;;
    backups)
        list_backups
        ;;
    validate)
        validate_all_skills
        ;;
    -h|--help)
        show_status
        ;;
    *)
        show_status
        ;;
esac
