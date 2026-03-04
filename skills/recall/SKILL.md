---
name: recall
description: Persistent memory for Claude across conversations. Use when starting any task, before writing or editing code, before making decisions, when user mentions preferences or conventions, when user corrects your work, or when completing a task that overcame challenges. Ensures Claude never repeats mistakes and always applies learned patterns.
version: "2.0.0"
license: "MIT"
---

# Memory Management

Persistent memory system that ensures Claude never repeats mistakes and always applies learned patterns across conversations.

## 4 Tools

- `mcp__claude-recall__load_rules` - Load all active rules before starting work. No query needed.
- `mcp__claude-recall__store_memory` - Store a rule or learning. Immediately active in this conversation.
- `mcp__claude-recall__search_memory` - Search memories by keyword. Use to find specific memories before making decisions.
- `mcp__claude-recall__delete_memory` - Delete a specific memory by ID. Use search_memory first to find the ID.

## When to Use

- **Starting any task** - Call `load_rules` before Write, Edit, or significant Bash operations
- **When user corrects your work** - Call `store_memory` with `metadata.type: "correction"`
- **When user mentions preferences** - Call `store_memory` with `metadata.type: "preference"`
- **After overcoming a challenge** - Call `store_memory` with `metadata.type: "failure"`
- **DevOps/workflow rules** - Call `store_memory` with `metadata.type: "devops"`

## Key Directives

1. **ALWAYS load rules before acting** — Call `load_rules` before Write, Edit, or significant Bash operations
2. **ACT on loaded rules** — After loading, state which rules apply to your current task before proceeding. If a rule conflicts with your plan, follow the rule. If none apply, say so. Loading without applying is the same as not loading.
3. **Cite applied rules inline** — When a rule influences your work: (applied from memory: <rule>)
4. **Ask before storing** — Before calling `store_memory`, tell the user what you plan to store and ask for confirmation
5. **Capture corrections immediately** — User fixes are highest priority (still ask first)
6. **Never store secrets** — No API keys, passwords, tokens, or PII

## Quick Reference

### Load Rules (Before Every Task)

```
mcp__claude-recall__load_rules({})
```

Returns all active preferences, corrections, failures, and devops rules in one call. Deterministic and complete.

### Store Memory (When Something Important Happens)

```
mcp__claude-recall__store_memory({
  "content": "Description of what to remember",
  "metadata": { "type": "preference|correction|devops|failure" }
})
```

Returns the stored rule with an `activeRule` field and `_directive` to apply it immediately. No need to call `load_rules` again.

## Same-Session Rules

When you call `store_memory`, the response includes:
- `activeRule`: The stored content formatted as a rule
- `_directive`: Instructions to apply the rule immediately

This means rules stored mid-conversation are active right away without reloading.

## What Gets Stored

### Automatic Capture (You Don't Need to Store)

The system auto-captures when users say:
- "I prefer X" / "Always use X" / "Never do X" -> Preferences
- "We use X for Y" / "Tests go in X" -> Project conventions
- "This is a [type] project" -> Project context

### Manual Storage Required

Store these explicitly:

**Corrections** (highest priority):
```
User: "No, put tests in __tests__/ not tests/"
-> Store: "CORRECTION: Test files go in __tests__/ directory, not tests/"
   metadata: { "type": "correction" }
```

**Complex workflows**:
```
-> Store: "Deploy process: 1) npm test 2) docker build 3) push to ECR 4) kubectl apply"
   metadata: { "type": "devops" }
```

**Learning cycles** (fail -> fix -> success):
```
-> Store: "REST API failed due to CORS. Solution: Use GraphQL endpoint instead."
   metadata: { "type": "failure" }
```

## Memory Priority Order

1. **Corrections** - User explicitly fixed a mistake (HIGHEST)
2. **DevOps** - Git, testing, deploy, architecture patterns
3. **Preferences** - Code style, tool choices, conventions
4. **Failures** - Learning cycles and past mistakes

## What NOT to Store

Never store:
- API keys, tokens, passwords, secrets
- Personal emails, phone numbers, addresses
- Database connection strings with credentials
- Any sensitive configuration values

Safe to store:
- "We use JWT for auth" (pattern, not credentials)
- "API base URL is https://api.example.com" (non-sensitive)
- "PostgreSQL for production, SQLite for tests" (tool choice)

## Skill Crystallization

As memories accumulate, Claude Recall automatically generates skill files in `.claude/skills/auto-*/`.
These load natively in future sessions — no tool call needed.

**How it works:** After each `store_memory`, the system checks if any topic has enough
memories to form a skill (3+ for most types, 5+ for preferences). If so, it writes
a SKILL.md file that Claude Code loads automatically.

**CLI commands:**
- `npx claude-recall skills list` — see generated skills
- `npx claude-recall skills generate --force` — force regeneration
- `npx claude-recall skills clean --force` — remove all auto-generated skills

## Automatic Capture Hooks

Claude Recall registers hooks on three Claude Code events to capture memories automatically — no MCP tool call needed:

| Hook | Event | What it captures |
|------|-------|-----------------|
| `correction-detector` | UserPromptSubmit | User corrections, preferences, and project knowledge from natural language |
| `memory-stop` | Stop | Corrections, preferences, failures, and devops patterns from the last 6 transcript entries |
| `precompact-preserve` | PreCompact | Broader sweep of up to 50 transcript entries before context compression |

**Key behaviors:**
- **LLM-first classification** via Claude Haiku — detects natural statements like "we use tabs here" or "tests go in \_\_tests\_\_/" that regex would miss
- Automatic zero-config: picks up `ANTHROPIC_API_KEY` from the Claude Code session environment
- Silent regex fallback when API key is unavailable or API call fails
- Batch classification: Stop and PreCompact hooks send all texts in a single API call
- Near-duplicate detection via Jaccard similarity (55% threshold) prevents redundant storage
- Per-event limits: 3 (Stop), 5 (PreCompact) to prevent DB flooding
- Always exits 0 — hooks never block Claude

**Setup:** Run `npx claude-recall setup --install` to register hooks in `.claude/settings.json`.

## Example Workflows

### Starting a New Task

```
1. User: "Add user authentication"

2. Load rules first:
   mcp__claude-recall__load_rules({})

3. Response includes:
   ## Preferences
   - auth_method: JWT with httpOnly cookies
   ## Corrections
   - Never use localStorage for auth tokens

4. Implement using JWT + httpOnly cookies (not sessions, not localStorage)

5. User approves -> Done (no need to store, just applied existing knowledge)
```

### User Corrects Your Work

```
1. You: Created auth with localStorage tokens

2. User: "No, we always use httpOnly cookies for security"

3. Fix the code

4. Ask: "I'd like to remember: always use httpOnly cookies for auth tokens, never localStorage. Store this?"

5. User: "Yes"

6. Store the correction:
   mcp__claude-recall__store_memory({
     "content": "CORRECTION: Always use httpOnly cookies for auth tokens, never localStorage",
     "metadata": { "type": "correction" }
   })

7. Response includes activeRule - apply it immediately
```

### Overcoming a Challenge

```
1. Tried: Redis sessions for auth
   Failed: "Session sync issues in k8s cluster"

2. User suggested: "Try stateless JWT"

3. Implemented JWT -> Works!

4. Ask: "I'd like to remember: Redis sessions fail in k8s due to sync issues; use stateless JWT instead. Store this?"

5. User: "Yes"

6. Store the learning:
   mcp__claude-recall__store_memory({
     "content": "Auth in k8s: Redis sessions failed (sync issues). JWT stateless tokens work correctly.",
     "metadata": { "type": "failure", "learning_cycle": true }
   })
```

## Troubleshooting

**Load rules returns nothing:**
- This may be a new project with no history yet
- Store rules as you learn them with `store_memory`

**Automatic capture missed something:**
- Store it manually with appropriate type
- Future `load_rules` calls will find it

---

**The Learning Loop**: Load rules -> Apply -> Execute -> Capture outcomes -> Better next time
