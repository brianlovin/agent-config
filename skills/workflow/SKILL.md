---
name: workflow
description: "Workflow orchestration for complex coding tasks. Use when a task involves 3+ steps, spans multiple files, or requires architectural decisions — enforcing upfront planning, subtask breakdown, subagent delegation, cross-file verification, and structured bug investigation. Use when: multi-step feature implementation, complex bug fixes requiring investigation across multiple files, large-scale refactoring, architectural changes, or any task needing a validated execution plan before coding begins."
---

## Workflow Orchestration

### 1. Plan Mode Default

- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately — don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

**Example plan mode output** (written to `tasks/todo.md` before coding begins):
```
## Task: Add OAuth2 login support

- [ ] Audit existing auth middleware in `src/auth/`
- [ ] Design token storage schema (DB migration required)
- [ ] Implement OAuth2 callback handler in `src/routes/auth.ts`
- [ ] Wire up session persistence and expiry
- [ ] Write integration tests covering happy path + token refresh
- [ ] Verify no regressions in existing session-based login
```

### 2. Subagent Strategy

- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution

### 3. Self-Improvement Loop

- After ANY correction from the user: update `tasks/lessons.md` with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project

**Example `tasks/lessons.md` entry:**
```
## Lesson: 2024-06-10 — Don't mutate shared config objects

**What happened:** Modified a shared config object in place; broke unrelated tests.
**Root cause:** Assumed config was local scope; it was imported by reference.
**Rule:** Always deep-clone config objects before modification. Use `structuredClone()` or spread at the call site.
```

### 4. Verification Before Done

- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### 5. Demand Elegance (Balanced)

- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes — don't over-engineer
- Challenge your own work before presenting it

### 6. Autonomous Bug Fixing

- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests — then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how

## Task Management

1. **Plan First**: Write plan to `tasks/todo.md` with checkable items
2. **Verify Plan**: Check in before starting implementation
3. **Track Progress**: Mark items complete as you go
4. **Explain Changes**: High-level summary at each step
5. **Document Results**: Add review section to `tasks/todo.md`
6. **Capture Lessons**: Update `tasks/lessons.md` after corrections

**Example completed `tasks/todo.md` review section:**
```
## Review

- [x] OAuth2 callback handler implemented and tested
- [x] Session expiry confirmed via manual smoke test + unit tests
- [x] No regressions: existing session login tests all green
- Lesson captured: always validate redirect_uri against allowlist before exchange
```

## Core Principles

- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact**: Changes should only touch what's necessary. Avoid introducing bugs.
