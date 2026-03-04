# claude-config

My agent configuration for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) and Codex, synced across machines via symlinks.

## Quick start

```bash
git clone https://github.com/andrewwashuta/claude-config.git
cd claude-config
./install.sh
```

## What's included

### Settings
- `settings.json` - Global permissions and preferences
- `statusline.sh` - Custom statusline showing token usage

### Skills
Reusable capabilities that your coding agents can invoke.

| Skill | Description |
|-------|-------------|
| `agent-browser` | Browser automation for web testing and interaction |
| `ai-elements` | Intelligent documentation for the AI Elements component library |
| `bun` | Use Bun instead of Node.js/npm/pnpm/vite |
| `chrome-webstore-release-blueprint` | Chrome Web Store API release automation |
| `deslop` | Remove AI-generated code slop |
| `favicon` | Generate favicons from a source image |
| `find-skills` | Discover and install agent skills |
| `fix-sentry-issues` | Triage and fix production issues via Sentry MCP |
| `knip` | Find and remove unused files, dependencies, and exports |
| `playwriter` | Control Chrome tabs via Playwriter CLI |
| `rams` | Accessibility and visual design review |
| `react-doctor` | Diagnose and fix React codebase health issues |
| `recall` | Persistent memory across conversations |
| `reclaude` | Refactor CLAUDE.md for progressive disclosure |
| `sentry` | Sentry error monitoring patterns for Next.js |
| `simplify` | Code simplification specialist |
| `skill-creator` | Guide for creating effective skills |
| `tdd` | Test-driven development with red-green-refactor |
| `workflow` | Workflow orchestration for complex coding tasks |

### Agents
- `security-reviewer` - Security review subagent

## Managing your config

```bash
# See what's synced vs local-only
./sync.sh

# Preview what install would do
./install.sh --dry-run

# Add a local skill to the repo
./sync.sh add skill my-skill
./sync.sh push

# Pull changes on another machine
./sync.sh pull

# Remove a skill from repo (keeps local copy)
./sync.sh remove skill my-skill
./sync.sh push
```

### Safe operations with backups

All destructive operations create timestamped backups:

```bash
# List available backups
./sync.sh backups

# Restore from last backup
./sync.sh undo
```

### Validate skills

```bash
./sync.sh validate
```

Skills must have a `SKILL.md` with frontmatter containing `name` and `description`.

## Testing

Tests use [Bats](https://github.com/bats-core/bats-core) (Bash Automated Testing System).

```bash
# Install bats (one-time)
brew install bats-core

# Run all tests
bats tests/

# Run specific test file
bats tests/install.bats
bats tests/sync.bats
bats tests/validation.bats
```

Tests run in isolated temp directories and don't affect your actual `~/.claude` config.

## Directory structure

```
claude-config/
├── settings.json      # Claude Code settings
├── statusline.sh      # Optional statusline script
├── skills/            # Skills (subdirectories with SKILL.md)
├── agents/            # Subagent definitions
├── tests/             # Bats tests
└── install.sh         # Symlink installer
```

## See also

- [Claude Code docs](https://docs.anthropic.com/en/docs/claude-code)
