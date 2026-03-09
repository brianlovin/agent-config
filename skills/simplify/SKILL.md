---
name: simplify
description: Simplifies and refines recently modified code by renaming variables for clarity, extracting repeated logic into functions, simplifying conditionals, removing redundant abstractions, and improving formatting — all without changing functionality. Use when asked to clean up, refactor, polish, tidy up, or make code more readable after writing or modifying it.
---

Analyze recently modified code and apply refinements that:

1. **Preserve Functionality**: Never change what the code does - only how it does it. All original features, outputs, and behaviors must remain intact.

2. **Apply Project Standards**: Follow the established coding standards from CLAUDE.md including:

   - Use ES modules with proper import sorting and extensions
   - Prefer `function` keyword over arrow functions
   - Use explicit return type annotations for top-level functions
   - Follow proper React component patterns with explicit Props types
   - Use proper error handling patterns (avoid try/catch when possible)
   - Maintain consistent naming conventions

3. **Enhance Clarity**: Simplify code structure by:

   - Renaming unclear variables and functions for self-documenting intent
   - Extracting repeated logic into named functions
   - Reducing unnecessary complexity and nesting
   - Eliminating redundant code and abstractions
   - Consolidating related logic
   - Removing unnecessary comments that describe obvious code
   - IMPORTANT: Avoid nested ternary operators — prefer switch statements or if/else chains for multiple conditions

   **Example — variable renaming:**
   ```ts
   // Before
   const d = new Date();
   const x = users.filter(u => u.a === true);

   // After
   const today = new Date();
   const activeUsers = users.filter(u => u.isActive === true);
   ```

   **Example — function extraction:**
   ```ts
   // Before
   const result = items.map(i => ({ id: i.id, label: i.name.trim().toLowerCase(), active: i.status === 'enabled' }));

   // After
   function normaliseItem(item: Item): NormalisedItem {
     return { id: item.id, label: item.name.trim().toLowerCase(), active: item.status === 'enabled' };
   }
   const result = items.map(normaliseItem);
   ```

   **Example — nested ternary → switch:**
   ```ts
   // Before
   const label = status === 'active' ? 'Active' : status === 'pending' ? 'Pending' : 'Unknown';

   // After
   function getLabel(status: string): string {
     switch (status) {
       case 'active': return 'Active';
       case 'pending': return 'Pending';
       default: return 'Unknown';
     }
   }
   ```

4. **Maintain Balance**: Avoid these anti-patterns:

   - Overly clever solutions that sacrifice readability
   - Combining too many concerns into a single function or component
   - Removing helpful abstractions that aid organization
   - Prioritizing fewer lines over clarity (e.g., dense one-liners, nested ternaries)
   - Making code harder to debug or extend

5. **Focus Scope**: Only refine code that has been recently modified or touched in the current session, unless explicitly instructed to review a broader scope.

## Refinement Process

1. Identify the recently modified code sections
2. Analyze for opportunities to improve clarity and consistency
3. Apply project-specific best practices and coding standards from CLAUDE.md
4. Refactor incrementally — rename variables, extract functions, simplify conditionals
5. **Validate that functionality is preserved**: run `npm test` (or the project's test command), or manually execute the changed function with known inputs and verify the output matches the pre-refactor behaviour. If any test fails, identify the specific change that caused the failure by reverting one change at a time, then attempt a narrower refinement or skip that particular improvement
6. Document only significant changes that affect understanding
