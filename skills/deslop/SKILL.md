---
name: deslop
description: Remove AI-generated code slop from the current branch. Use after writing code to clean up unnecessary comments, defensive checks, and inconsistent style — also useful when asked to 'clean up generated code', 'remove AI boilerplate', 'remove AI artifacts', 'refactor AI code', or 'remove redundant error handling'. Actions include stripping unhelpful inline comments, removing abnormal try/catch blocks, eliminating `any` casts, simplifying verbose patterns, and standardising naming conventions to match the rest of the codebase.
---

# Remove AI code slop

Check the diff against main, and remove all AI generated slop introduced in this branch.

## Step 1 — Review the diff

```bash
git diff main...HEAD
```

## Step 2 — Identify and remove slop

This includes:
- Extra comments that a human wouldn't add or is inconsistent with the rest of the file
- Extra defensive checks or try/catch blocks that are abnormal for that area of the codebase (especially if called by trusted / validated codepaths)
- Casts to `any` to get around type issues
- Verbose or over-engineered patterns where a simpler form is idiomatic in this codebase
- Any other style that is inconsistent with the file

### Before / after examples

**Unnecessary comment slop:**
```ts
// Before
// Check if the user exists before proceeding
const user = await getUser(id);

// After
const user = await getUser(id);
```

**Abnormal defensive check slop:**
```ts
// Before (in a trusted internal codepath that already validates input)
if (!id || typeof id !== 'string') {
  throw new Error('Invalid id');
}
const user = await getUser(id);

// After
const user = await getUser(id);
```

## Step 3 — Validate

Run the project's tests or type-checker after making changes to confirm nothing is broken:

```bash
# examples — use whatever is appropriate for this project
npm test
npx tsc --noEmit
```

## Step 4 — Report

Report at the end with only a 1-3 sentence summary of what you changed.
