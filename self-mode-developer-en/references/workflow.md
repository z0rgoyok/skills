# Development Workflow

## 1. Define the Action Contract

Distinguish among these modes: explain, investigate, design, implement, verify, and publish. The phrase “we’re still thinking” keeps the work in read-only mode (`read-only`); an instruction to act authorizes only the scope already discussed.

## 2. Reconstruct the Factual Context

- read the repository instructions and relevant skills;
- inspect the Git state and preserve the user's changes;
- find the original requirement, architectural decisions, and the history of the disputed area;
- trace the path from the public entry point to the owner of the behavior, using the project's primary navigation tool;
- distinguish known debt and a pre-existing failure from a defect introduced by the current change.

This stage is complete when you can explain in plain language the objective, the current data or control flow, and where the change belongs.

## 3. Choose a Small, Verifiable Slice

State the outcome, the protected invariant, and the minimum set of files or modules. Break a large migration into steps that each preserve a working build, a clear boundary, and the ability to compare behavior.

## 4. Implement at the Right Boundary

- change the owner of the rule, not the nearest consumer;
- when domain knowledge is repeated, look for a shared solution;
- preserve KISS when there is no confirmed shared rule;
- update the related contract, schema, and documentation together with the code;
- avoid incidental scope expansion that the outcome does not require.

## 5. Prove It Locally

First run the narrowest checks that cover the changed risk. Then widen the verification scope to dependent modules. A failed check must lead to diagnosing the cause, not to a mechanical workaround.

## 6. Review and Correct

Ask a fresh reviewer for the first independent verdict when the cost of an error justifies it. Verify every finding against the code and contract. Return the fixes to the same reviewer for verification with the retained context. Repeat until there are no material findings or an explicit iteration boundary is reached.

## 7. Complete the Full Gate

Before delivery, run the final checks required by the risk and project rules. Expensive verification paths may be skipped at an intermediate step only when there is reliable evidence that their inputs have not changed.

## 8. Record and Hand Off

Commit, push, create an MR/PR, publish, or update an external tracker when the request includes the action or explicitly authorizes it. The delivery history describes the outcome for both the product and the code. The final report lists the checks performed, the result, anything left unverified, and the residual risk.

## Continuing Across Sessions

Preserve the objective, decisions, verification state, open findings, and next step in the project's standard artifact. The `handoff` must let another session continue without rereading the entire conversation or duplicating sources of truth.
