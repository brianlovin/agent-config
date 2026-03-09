---
name: tdd
description: "Test-driven development with red-green-refactor loop: write failing tests first, implement minimal passing code, then refactor for quality. Use when user wants to build features or fix bugs using TDD, mentions \"red-green-refactor\", wants integration tests, or asks for test-first development."
---

# Test-Driven Development

## Philosophy

**Core principle**: Tests should verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't.

**Good tests** are integration-style: they exercise real code paths through public APIs and describe _what_ the system does, not _how_. A good test reads like a specification — "user can checkout with valid cart."

**Rules**:
- Use public interfaces only — never test private methods or internal collaborators
- If a test breaks during a refactor where behavior hasn't changed, the test is testing implementation, not behavior

See [tests.md](tests.md) for examples and [mocking.md](mocking.md) for mocking guidelines.

## Behavior-Focused vs. Implementation-Focused Tests

A quick illustration of the distinction (Python, but the principle is language-agnostic):

```python
# BAD — tests implementation detail (internal method name, internal state)
def test_cart_internal():
    cart = Cart()
    cart._item_list.append(Item("book", 10))   # reaches into internals
    assert cart._calculate_subtotal() == 10    # calls private method

# GOOD — tests observable behavior through public interface
def test_cart_total_reflects_added_items():
    cart = Cart()
    cart.add_item("book", price=10)
    cart.add_item("pen",  price=2)
    assert cart.total() == 12
```

The good test survives any internal refactor as long as `add_item` and `total` keep their contract.

## Anti-Pattern: Horizontal Slices

**DO NOT write all tests first, then all implementation.** Tests written in bulk test _imagined_ behavior and become insensitive to real changes.

```
WRONG (horizontal):
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

RIGHT (vertical):
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  RED→GREEN: test3→impl3
  ...
```

**Correct approach**: Vertical slices via tracer bullets — one test → one implementation → repeat.

## Workflow

### 1. Planning

Before writing any code:

- [ ] Confirm with user what interface changes are needed
- [ ] Confirm with user which behaviors to test (prioritize)
- [ ] Identify opportunities for [deep modules](deep-modules.md) (small interface, deep implementation)
- [ ] Design interfaces for [testability](interface-design.md)
- [ ] List the behaviors to test (not implementation steps)
- [ ] Get user approval on the plan

Ask: "What should the public interface look like? Which behaviors are most important to test?"

**You can't test everything.** Confirm with the user exactly which behaviors matter most. Focus testing effort on critical paths and complex logic, not every possible edge case.

### 2. Tracer Bullet

Write ONE test that confirms ONE thing about the system:

```
RED:   Write test for first behavior → test fails
GREEN: Write minimal code to pass → test passes
```

This is your tracer bullet - proves the path works end-to-end.

**Example RED→GREEN cycle** (pytest):

```python
# --- RED: write the test first, run it, watch it fail ---
def test_user_can_register_with_valid_email():
    service = UserService()
    user = service.register(email="alice@example.com", password="s3cret")
    assert user.id is not None
    assert user.email == "alice@example.com"

# Running now → NameError / AttributeError: UserService does not exist  ✗

# --- GREEN: write the minimal implementation to make it pass ---
import uuid

class UserService:
    def register(self, email: str, password: str):
        return User(id=uuid.uuid4(), email=email)

class User:
    def __init__(self, id, email):
        self.id = id
        self.email = email

# Running now → passes  ✓
# (password hashing, persistence, validation come in later cycles)
```

### 3. Incremental Loop

For each remaining behavior:

```
RED:   Write next test → fails
GREEN: Minimal code to pass → passes
```

Rules:

- One test at a time
- Only enough code to pass current test
- Don't anticipate future tests
- Keep tests focused on observable behavior

### 4. Refactor

After all tests pass, look for [refactor candidates](refactoring.md):

- [ ] Extract duplication
- [ ] Deepen modules (move complexity behind simple interfaces)
- [ ] Apply SOLID principles where natural
- [ ] Consider what new code reveals about existing code
- [ ] Run tests after each refactor step

**Never refactor while RED.** Get to GREEN first.

## Checklist Per Cycle

```
[ ] Test describes behavior, not implementation
[ ] Test uses public interface only
[ ] Test would survive internal refactor
[ ] Code is minimal for this test
[ ] No speculative features added
```
