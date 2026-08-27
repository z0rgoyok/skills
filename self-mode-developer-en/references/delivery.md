# Documentation and Delivery

## Documentation as a Record of Intent

Start with the product goal and observable outcome. Then record the decision, boundaries, invariants, significant rejected alternatives, and the trigger for future evolution. Add enough implementation detail for the next implementer to make an unambiguous decision without copying the original conversation.

An ADR is warranted for a significant and durable architectural choice. Several closely related decisions can be combined when they share one intent and one boundary.

## Self-Contained Artifacts

A skill (`skill`), runbook (`runbook`), handoff (`handoff`), report, and implementation plan must answer five questions:

1. What outcome is required?
2. What context has already been confirmed?
3. Which decisions and invariants have been established?
4. How can readiness be demonstrated?
5. What should happen next?

Keep each meaning in a single source of truth. Temporary files, logs, and runtime state (`runtime`) must either have a designated location and cleanup policy or be excluded from the delivered result.

## Git and Public History

- A commit represents one meaningful change and names the outcome rather than listing files.
- Maintain a clean, explainable history without accidental execution artifacts.
- Match the language of the history and documentation to the audience: use Russian for an internal Russian-speaking environment; a public repository usually requires an English README, `SKILL.md`, and commit history.
- Use force-push, squash, and other history rewriting only when the context and permission are explicit.

## MR/PR

The description explains the delivered code and its product and technical outcome. The internals of the agent pipeline remain process evidence and do not replace the substance of the change.

Include:

- what changes for the system or user;
- the key decision and boundary;
- material risks and compatibility;
- validation performed;
- what was intentionally left out of scope.

## Final Report

Lead with the outcome. Then briefly list the changed contracts or artifacts, the validation performed, and the remaining constraints. Do not declare the work complete merely because code exists or the agent is confident: readiness is confirmed by the agreed gate (`gate`).
