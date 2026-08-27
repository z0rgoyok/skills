# Quality and Review

## Risk-Driven Verification

Every material check answers one question: what outcome, invariant, or prohibited effect does it prove? The number of tests is not the goal.

Preferred progression:

1. a focused test of the changed rule;
2. a boundary or contract test between modules;
3. an integration scenario that follows the real data path;
4. the full local gate (`gate`);
5. CI or the external delivery path required by the project rules.

Remove duplicate checks unless they protect a distinct risk. For a defect fix, first obtain reproducible evidence of the problem when doing so is proportionate to the task.

Derive the expected test result from the requirement, a domain example, or an independent model. A copy of the production algorithm in a test validates itself and is not independent evidence.

## Review Slice

By default, conduct the review on an explicitly prepared, immutable slice, usually a staged diff or a committed revision. The party requesting the review prepares the slice; the reviewer verifies its identity and rejects an ambiguous target unless the user specified a different mode.

## Two Review Axes

- **Alignment with intent:** requirements, product outcome, architectural decisions, constraints, and prohibited effects.
- **Engineering quality:** correctness, data and states, lifecycle, security, concurrency, errors, compatibility, testability, duplication, and repository standards.

Report only actual findings. Every finding must include an observable scenario, consequence, evidence in the slice, and priority. A general recommendation without a defect belongs under improvements and must not be presented as a blocking issue.

## Review as an Evidence-Based Dialogue

- A reviewer can be wrong; verify each finding independently.
- Read the author's response and compare it with the contract instead of defending the review's original wording.
- After a fix, verify the same scenario and adjacent cases governed by the same rule.
- Keep the original reviewer for follow-up review when the accumulated context is valuable; bring in a fresh reviewer for an independent final pass when the risk is significant.
- Keep the tone respectful and specific even when the verdict is severe.

## Comments and Documentation Near the Code

A comment explains the purpose, reason, invariant, or protected risk. Leave obvious behavior, field names, and syntax in the code without restating them. Human-readable text follows the project's language contract; preserve exact identifiers.

## An Honest Gate

“Passed” means the check was actually run and its result verified. In the final report, list separately:

- what was run and passed;
- what was run and failed;
- what was intentionally not run;
- what residual risk remains.
