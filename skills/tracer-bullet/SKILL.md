---
name: tracer-bullet
description: >
  Plan and execute risky technical changes by identifying the riskiest assumption,
  designing a minimal end-to-end test that validates it, then growing the implementation
  in phased red-green-refactor cycles. Produces a persistent plan file for multi-session
  continuity.

  Use when: (1) a proposed approach has an assumption that could invalidate the entire
  design, (2) migrating to a new architecture or integration pattern, (3) adopting an
  unfamiliar technology or API, (4) any multi-session implementation where validating
  feasibility early saves significant rework.

  Trigger phrases: "tracer bullet", "validate the approach", "riskiest assumption",
  "prove this works first", "thin vertical slice".

  Do NOT use for: single-file changes, well-understood patterns, tasks where the
  approach is known to work, or pure refactoring of existing code.
---

# Tracer Bullet

Plan risky technical changes by testing the riskiest assumption first with a thin
end-to-end slice, then grow the implementation in disciplined phases.

Combines three techniques: Riskiest Assumption Test (what to validate), tracer bullet
(thin vertical slice to validate it), and red-green-refactor (execution cadence).

For background research, see [references/research.md](references/research.md).

## Workflow

Two stages: **Plan** (interview, identify risk, design tracer, write plan) and
**Execute** (run phases via red-green-refactor, update plan progress).

### Stage 1: Plan

#### 1. Read context

Read CLAUDE.md, .ai/MEMORY.md, existing tests, and CI config. Understand the stack,
test framework, and project conventions before asking questions.

#### 2. Interview (3-4 questions max)

Ask targeted, opinionated questions with concrete tradeoffs attached. Present choices,
not open-ended prompts. Focus on decisions that change the plan shape:

**Always ask:**
- What is the riskiest assumption? (The thing that could invalidate the whole approach.)
  Present your best guess as the first option based on codebase exploration.
- What does "done" look like for the tracer bullet? (Minimal proof the assumption holds.)

**Ask when relevant:**
- Testing strategy: what tools, where do tests run, what environment constraints?
- Breaking change or incremental? Backward compatibility requirements?
- Existing work in progress that affects the plan?
- Execution environment: containers, CI, local, specific platforms?

Do not ask questions whose answers are discoverable from the codebase.

#### 3. Classify the risk

Identify which type of risk the tracer bullet must address:

- **Integration risk**: "Will external tool X accept input Y?" Tracer bullet: call the
  tool with real inputs, assert expected outputs.
- **Performance risk**: "Can this handle N items in T time?" Tracer bullet: benchmark
  with realistic data volume.
- **Feasibility risk**: "Is this possible with the current API?" Tracer bullet: build
  the minimal proof-of-concept that exercises the critical API surface.
- **Data risk**: "Does the data actually look like we assume?" Tracer bullet: load real
  data, assert shape and invariants.

This classification informs the tracer bullet design. An integration risk needs a real
end-to-end test against the external system. A feasibility risk may need only a unit
test exercising the API.

#### 4. Design the tracer bullet

The tracer bullet is always Phase 0 of the plan. Design criteria:

- Tests exactly one riskiest assumption, not two
- Touches all critical layers end-to-end (not a unit test of one component)
- Uses production-quality code and real tooling (not a throwaway prototype)
- Has a clear exit criterion: pass = proceed, fail = pivot or spike alternative
- Runs in the project's actual test infrastructure

#### 5. Write the plan

Choose a plan file location that survives across sessions. Look for an existing
convention in the project (e.g., `.ai/plan.md`, `docs/plan.md`, a `plans/` directory).
If none exists, ask the user where they want it. Ensure it's gitignored if it contains
session-specific state. Structure:

```markdown
# [Title]

## Context
Why this change is needed. What problem it solves. 1-2 paragraphs max.

## Riskiest assumption
One sentence. What could kill the approach.

## Phase 0: Tracer bullet
Goal, test design, exit criterion (pass = proceed, fail = pivot to what).

## Phase 1..N: Implementation phases
Each phase:
- Goal (one sentence)
- Key changes (files, functions, behaviors)
- Red-green-refactor cycle: what test to write first, what makes it pass
- Commit message

## Progress
- [ ] Phase 0: Tracer bullet
- [ ] Phase 1: ...
- [ ] Phase N: ...
```

Keep phases small enough to complete in one session. Each phase produces one commit.
Order phases by dependency (what must exist before what), not by difficulty.

### Stage 2: Execute

#### Run Phase 0 first

Execute the tracer bullet. This is the go/no-go gate:

- **Pass**: The assumption holds. Update plan file progress, proceed to Phase 1.
- **Fail**: The assumption is wrong. Stop. Document what was learned. Either pivot to
  an alternative approach (design a new tracer bullet for it) or spike to acquire more
  knowledge before deciding.

Do not skip Phase 0. Do not combine it with Phase 1.

#### Run remaining phases

For each subsequent phase, use `/red-green-refactor`:
1. Write a failing test (red)
2. Make it pass (green), commit
3. Refactor, commit
4. Update plan file progress checklist

After each phase, verify the full test suite still passes. If a phase breaks something,
fix it before proceeding.

#### Multi-session continuity

At session end, ensure the plan file reflects current progress. The plan is the
coordination artifact that lets a new session resume where the previous one left off.
Read the plan file at the start of every session.

## Guardrails

- **One assumption per tracer bullet.** Testing two assumptions at once means you can't
  tell which one failed.
- **Real tests, not console output.** The tracer bullet must produce an automated test
  that can be re-run, not a manual verification.
- **Exit criteria before execution.** Define what pass/fail looks like before writing
  the test, not after seeing results.
- **Plan is append-only during execution.** Update progress checkboxes and add learnings,
  but do not restructure phases mid-execution without user approval.
- **Tracer bullet code is kept.** It becomes the skeleton for the full implementation.
  This is not a prototype to be thrown away.

## Related skills

- `/red-green-refactor`: Execute individual phases. Tracer bullet handles planning and
  Phase 0; red-green-refactor handles Phase 1+.
- `/technical-spec-writer`: For larger changes that need a formal spec before the tracer
  bullet plan. The spec feeds into the tracer bullet's context section.
- `/end-of-session`: Flush plan progress and learnings to disk.
