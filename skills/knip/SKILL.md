---
name: knip
description: Run knip to find and remove unused files, dependencies, and exports. Use when cleaning up dead code, pruning unused dependencies, removing orphaned files, auditing dependencies, or finding unused imports and exports across a project.
---

# Knip Code Cleanup

Run knip to find and remove unused files, dependencies, and exports from this codebase.

## Setup

1. Check if knip is available:
   - Run `npx knip --version` to test
   - If it fails or is very slow, check if `knip` is in package.json devDependencies
   - If not installed locally, install with `npm install -D knip` (or pnpm/yarn/bun equivalent based on lockfile present)

2. Knip targets unused files, dependencies, and exports — not unused imports/variables inside files (use a linter for that).

## Workflow

Always follow this configuration-first workflow. Even for simple "run knip" or "clean up codebase" prompts, configure knip properly before acting on reported issues.

### Step 1: Understand the project

- Check what frameworks and tools the project uses (look at package.json)
- Check if a knip config exists (`knip.json`, `knip.jsonc`, or `knip` key in package.json)
- If a config exists, review it for improvements (see Configuration Best Practices below)

### Step 2: Run knip and read configuration hints first

```bash
npx knip
```

Focus on **configuration hints** before anything else. These appear at the top of the output and suggest config adjustments to reduce false positives.

### Step 3: Address hints by adjusting knip.json

Fix configuration hints before addressing reported issues. Common adjustments:
- Enable/disable plugins for detected frameworks
- Add entry patterns for non-standard entry points
- Configure workspace settings for monorepos

### Step 4: Repeat steps 2-3

Re-run knip after each config change. Repeat until configuration hints are resolved and false positives are minimized.

### Step 5: Address actual issues

Once the configuration is settled, work through reported issues. Prioritize in this order:

1. **Unused files** — address these first ("inbox zero" approach removes the most noise)
2. **Unused dependencies** — remove from package.json
3. **Unused devDependencies** — remove from package.json
4. **Unused exports** — remove or mark as internal
5. **Unused types** — remove, or configure `ignoreExportsUsedInFile` (see below)

### Step 6: Re-run and repeat

Re-run knip after each batch of fixes. Removing unused files often exposes newly-unused exports and dependencies.

## Configuration Best Practices

- **Never use `ignore` patterns** — hides real issues; always prefer specific solutions. Other `ignore*` options (`ignoreDependencies`, `ignoreExportsUsedInFile`) are fine.
- **Many unused exported types?** Add `ignoreExportsUsedInFile: { interface: true, type: true }` to handle types used only in the same file.
- **Remove redundant patterns** — knip already respects `.gitignore`; don't re-ignore `node_modules`, `dist`, `build`, `.git`.
- **Remove duplicate entry patterns** — auto-detected plugins already add standard entry points.
- **Config files showing as unused** (e.g. `vite.config.ts`) — enable/disable the corresponding plugin explicitly.
- **Dependencies matching Node.js builtins** (e.g. `buffer`, `process`) — add to `ignoreDependencies`.
- **Unresolved path alias imports** — add `paths` to knip config (uses tsconfig.json semantics).

## Production Mode

Use `--production` to focus on production code only:

```bash
npx knip --production
```

This excludes test files, config files, and other non-production entry points. Do NOT use `project` or `ignore` patterns to exclude test files — use `--production` instead.

## Cleanup Confidence Levels

### Auto-delete (high confidence):
- Unused exports clearly internal (not part of public API)
- Unused type exports
- Unused dependencies (remove from package.json)
- Clearly orphaned files (not entry points, not config files)

### Ask first (needs clarification):
- Files that might be entry points or dynamically imported
- Exports that might be part of a public API (`index.ts`, lib exports)
- Dependencies that might be used via CLI or peer dependencies
- Files in paths like `src/index`, `lib/`, or with "public"/"api" in the name

Use the AskUserQuestion tool to clarify before deleting these.

## Auto-fix

Once configuration is settled and you're confident in the results:

```bash
# Auto-fix safe changes (removes unused exports and dependencies)
npx knip --fix

# Auto-fix including file deletion
npx knip --fix --allow-remove-files
```

Only use `--fix` after the configuration-first workflow is complete.

## Error Handling

If knip exits with code 2 (unexpected error like "error loading file"):
- Check if a config file exists — if not, create `knip.json` in the project root
- Check for known issues at knip.dev
- Review the configuration reference for syntax/option errors
- Run knip again after fixes

## Common Commands

```bash
# Basic run
npx knip

# Production only (excludes test/config entry points)
npx knip --production

# Auto-fix what's safe
npx knip --fix

# Auto-fix including file deletion
npx knip --fix --allow-remove-files

# JSON output for parsing
npx knip --reporter json
```

## Notes

- Watch for monorepo setups — may need `--workspace` flag
- Some frameworks need plugins enabled in config
- Use ESLint or Biome for unused imports/variables inside files
