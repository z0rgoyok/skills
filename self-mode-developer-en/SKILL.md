---
name: self-mode-developer-en
description: "Design, implement, verify, and take development through delivery using an established engineering approach. Use for development tasks when the user asks to apply “my engineering approach”; do not let this skill override the requirements of the project or the specific task."
---

# Self Mode Developer — English

This skill reproduces the user's proven way of working: from product intent and the architectural boundary through implementation, independent review, verification, and capturing a successful process for reuse. It includes only approaches that have recurred and been positively validated; a historical habit does not become a rule merely because it existed.

## How to apply it

1. Always read the [engineering reasoning model](references/thinking-model.md).
2. Select the task branches that apply:
   - design, data models, APIs, modules, and system evolution — [architecture](references/architecture.md);
   - implementing a change from context through delivery — [workflow](references/workflow.md);
   - dependencies, CLIs, remote scripts, binary artifacts, container images, and Git dependencies — [supply-chain security](references/supply-chain-security.md);
   - tests, reviews, comments, and control points (`gate`) — [quality](references/quality-and-review.md);
   - parallel work, supporting agents, and status updates during a long session — [orchestration](references/agent-orchestration.md);
   - documentation, artifacts, Git, and handoff — [delivery](references/delivery.md).
3. If the output explains a decision, architecture, plan, rationale, or trade-off to a person, fully read and apply [i-have-adhd](../../../.agents/skills/i-have-adhd/SKILL.md) before replying. This is a filesystem link relative to the current `SKILL.md`; `i-have-adhd` does not need to appear in the current session's skill catalog. It governs presentation; this skill continues to govern the engineering decision, evidence, and completion criteria.
4. For a recognizable personal voice or a response written in the user's voice, also use `$denis-personality`.
5. When updating this skill, check the change against the [criteria for a proven approach](references/provenance.md).

## Invariants

- Act autonomously within the agreed scope. Expanding the scope and making significant external state changes require separate justification or permission.
- Before any commit in a Git repository, run `$code-review` and `$slopo-harness` against the final, unchanged slice. Resolve blocking findings and rerun the affected checks; tests, CI, and delivery gates do not replace these two controls. If either control is inapplicable or not configured, do not commit and explicitly report the blocker.
- The user's explicit current instruction and the repository rules take precedence over this profile.

## Completion criteria

The work is complete when the intent and the risk being protected against are clear, the change is implemented at the correct boundary, the checks prove the material invariants, review findings are resolved or rejected with justification, and the final report honestly separates completed work from what remains unverified.
