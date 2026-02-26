---
name: technical-spec-writer
description: Create comprehensive technical specifications for features and refactoring. Use when designing new features, refactoring components, or planning architectural changes. Guides full spec creation from concept to implementation with test-first approach, proper formatting, task lists, and dependency tracking.
---

# Technical Spec Writer

## Overview

This skill guides the creation of comprehensive technical specifications for software features and refactoring. Specs are living documents that capture design decisions, implementation details, test requirements, and task organization for complex work.

**When to use:** Use this skill when you need to document a feature, refactor, or architectural change that requires careful planning, test-first development, and multi-session coordination.

**Output:** A finalized spec document that's ready to commit and use across multiple Claude Code sessions.

## Spec Structure & Workflow

Technical specs follow a consistent format. The workflow is:

1. **Clarify requirements** - Ask clarifying questions to understand scope, trade-offs, and user preferences
2. **Explore codebase** - Understand existing code and patterns relevant to the spec
3. **Design the solution** - Plan the approach, architecture, and task breakdown
4. **Write the spec** - Document everything following the template below
5. **Scrutinize** - Review for completeness, consistency, and correctness
6. **Finalize & commit** - Set status to "Finalized" and commit to git

## Spec Template

**File naming:** `YYYY-MM-DD-<slug>.md` in your project's spec directory (e.g., `2026-02-18-production-readiness.md`)

**Frontmatter:**
```
# <Title>

**Date:** YYYY-MM-DD
**Status:** Draft | Finalized (ready for implementation)

## Goal

<1-3 sentences explaining what this spec accomplishes>

<Optional: numbered list of workstreams/sections if large>
```

**TDD Approach Section** (if applicable):
```markdown
### TDD Approach

Every section follows test-first development. Task lists are ordered: **write tests, then implement to make them pass.** Tests should be written against the intended interface/behavior before the production code exists. The test describes what correct looks like; the implementation makes it true.
```

**Test Infrastructure Section** (if applicable - include patterns for):
- Temp directories (`t.TempDir()`)
- Test isolation and cleanup
- Mocking/stubbing patterns
- Context setup
- Env var restoration

**Main Sections** (each section has):
1. **Current State** - How things work now (if refactoring) or the problem we're solving
2. **Design** - The approach, including pseudocode, architecture, or flowcharts
3. **Implementation Details** - Specific files, functions, interfaces to change
4. **Tasks** - Organized as:
   - Tests first (numbered, `- [ ] **Test:** ...`)
   - Implementation (numbered, `- [ ] Implement X`)
   - All with clear acceptance criteria
5. **Integration Points** - How this connects to other systems (if relevant)
6. **Future Extensions** - What could be added later

**Implementation Order Section:**
```markdown
## Implementation Order

Recommended sequencing (some tasks can be parallelized; dependencies noted):

1. **Section 1** -- description of why it's first
2. **Section 2** -- depends on Section 1; unblocks Section 3

**Parallelizable:** After step X, steps Y-Z can run in parallel. Step Y must finish before step Z can finish.
```

**Footer:**
```markdown
---

*Written in collaboration with Claude (Opus 4.6).*
```

## Key Principles

### Test-First (TDD)

Every spec should lead with tests, then implementation. Tests define the contract; implementation makes it pass.

**Pattern:**
- Tests list what should be true
- Implementation list is the work to make tests pass
- Tests describe behavior; implementation describes mechanics

### Task Organization

- Use checkboxes (`- [ ]`) for all tasks
- Start task text with **Test:** or **Implement:** (or a clear verb)
- Group related tasks (all tests together, then all implementation)
- Include acceptance criteria in task descriptions
- For complex tasks, add a comment or reference to the design section

### Dependencies & Sequencing

- Show which sections depend on others
- Identify what can be parallelized
- Note "blocking" tasks that unblock others
- Consider: configs → foundations → features → integrations

### Secret Safety

**Always include secret/API key safeguards:**
- No hardcoded secrets in config files (use env vars)
- Scrub secrets from logs/events/files
- Redact in debug output (show `Bearer ...xxxx` only)
- Include test coverage for secret handling

### Config & Initialization

- Show env var resolution order clearly
- Document default values
- Plan for legacy/migration scenarios
- Consider graceful degradation (app continues if optional feature fails)

### Error Handling

- Plan for failures (log warnings, don't crash)
- Show retry logic (if needed)
- Document when errors are critical vs. recoverable

### Context Threading

If multiple components need shared state (logger, config, verbose mode):
- Use `context.Context` to thread it through
- Show the setup in main/command startup
- Avoid global state
- Include context helper functions in test infrastructure

## Writing Tips

1. **Be specific.** "Add logging" is vague. "Add slog.Debug calls in executor.Run() before action dispatch" is clear.
2. **Include line numbers/file paths.** Reference actual code: `internal/config/config.go:52`
3. **Show pseudocode.** Don't assume code will "just work." Pseudo code shows the algorithm.
4. **Estimate scope.** How many tasks? How many files? Is this foundational or standalone?
5. **Clarify trade-offs.** When multiple approaches exist, explain why you chose one.
6. **Link sections.** "See section X for Y" helps readers navigate.
7. **Use tables.** For comparisons, integration points, or options:
   ```markdown
   | Path | What's written | How |
   |---|---|---|
   | config.yaml | static template | no secrets |
   | events.jsonl | user input + LLM responses | scrubbed via StateWriter |
   ```

## Scrutiny Checklist

Before finalizing, review:

- [ ] All sections have clear Current State / Design / Implementation
- [ ] Tests are listed before implementation for each section
- [ ] No circular dependencies in implementation order
- [ ] All env vars documented
- [ ] All new files/packages listed
- [ ] Secret/API key handling addressed
- [ ] Error handling covered (no crashes on failures)
- [ ] Migration/legacy path addressed (if applicable)
- [ ] Context threading clear (if used)
- [ ] Integration points documented
- [ ] Tests include isolation/cleanup patterns
- [ ] Implementation order has clear dependencies
- [ ] Scope is reasonable for a session or two

## Example Sections

**Config Section Example:**
```markdown
## 1. Generalize Provider Config

### Current State
- provider.name is optional (enables provider-specific behavior when set)
- api_key comes from OPENAI_API_KEY env var

### Changes
- provider.name becomes optional
- env var OPENAI_API_KEY overrides config

### Tasks

Tests first:
- [ ] **Test:** config loads with empty provider.name (no Venice params)
- [ ] **Test:** OPENAI_API_KEY overrides config file

Implement:
- [ ] Remove api_key from DefaultConfigYAML()
- [ ] Add applyEnvOverrides() function
```

**Logging Section Example:**
```markdown
## 4. Application Logging

### Design
- Use structured logging (language-specific: slog for Go, Python logging, etc.)
- Log file path: `~/.config/myapp/logs/app.log`
- `-v` / `--verbose` flag sets level to debug
- Sensitive data redacted via scrubber

### Tasks

Tests first:
- [ ] **Test:** Setup() creates log file and returns logger
- [ ] **Test:** log output is scrubbed (API key → [REDACTED])

Implement:
- [ ] Create logging package
- [ ] Write secret-scrubbing middleware
- [ ] Call Setup() in main entry point
```

## Related Resources

- **Template spec asset:** See `assets/template-spec.md` for a blank starting point
- **Existing specs:** Check your project's spec directory for examples of effective spec structure
- **Architecture docs:** Refer to your project's architecture or design documentation for existing patterns

---

*Written in collaboration with Claude (Opus 4.6).*
