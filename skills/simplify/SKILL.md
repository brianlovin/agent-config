---
name: simplify
description: >
  Simplifies recently modified code by renaming variables for clarity, extracting repeated logic
  into functions, flattening nested conditionals, and removing redundant abstractions. Activates
  when the user asks to clean up, refactor, polish, tidy, or make code more readable after writing it.
version: 1.0.1
license: MIT
---

## References

Consult these resources as needed:

- ./references/transformation-patterns.md -- Before/after examples for common simplification patterns

## Workflow

1. Identify recently modified code sections (use git diff or session context)
2. Analyze each section for simplification opportunities against project standards
3. Apply transformations — rename, extract, flatten, deduplicate — one concern at a time
4. Run existing tests to verify functionality is unchanged before committing refinements
5. Summarize what changed and why in the commit or response

## Quick Example

`if (a) { if (b) { if (c) { do() } } }` → early-return guards: `if (!a) return; if (!b) return; if (!c) return; do()`

See ./references/transformation-patterns.md for full before/after examples.

## Principles

1. **Preserve behavior** — never change what the code does, only how it reads
2. **Apply project standards** from CLAUDE.md (ES modules, `function` keyword, explicit return types, React Props types, consistent naming)
3. **Enhance clarity** — flatten nesting, extract repeated logic, rename for intent, remove redundant comments, avoid nested ternaries (prefer switch/if-else)
4. **Maintain balance** — don't over-simplify; keep helpful abstractions, avoid dense one-liners, prefer readability over fewer lines
5. **Focus scope** — only refine recently modified code unless told otherwise
