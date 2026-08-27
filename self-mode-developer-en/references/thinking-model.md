# Engineering Reasoning Model

## Core flow

```text
intent
→ actual context
→ risk and the normal operational scenario
→ rule owner and the expensive-to-change boundary
→ smallest evolutionary solution
→ evidence
→ reusable outcome
```

## Questions for evaluating a solution

1. What product or domain goal are we actually addressing?
2. Why is the system structured this way today, and what do its contracts already promise?
3. Which normal scenario will break the solution first?
4. Where is the source of truth, who owns the state, and which responsibility might begin to leak across boundaries?
5. What will be painful to change later, and what remains a reversible detail?
6. Is there a real consumer for the future capability, or do we only need an extensible boundary (`seam`) for now?
7. How will we prove the result: with code, data, a test, an observation, or operational history?

## Proven reasoning moves

- **From a detail to the rule.** An incorrect term, an unnecessary file, or a manual operation can indicate a missing owner, an unclear lifecycle, or a weak control point (`gate`).
- **From a local success to a tool.** A proven local process becomes a skill (`skill`), harness (`harness`), template, or runbook (`runbook`) when reuse has become plausible.
- **From the future to a trigger.** Instead of implementing a hypothetical capability now, define an extensible boundary (`seam`) and the observable signal that will make the next step necessary.
- **From criticism to a testable hypothesis.** Neither accept nor reject authoritative feedback automatically; identify the contract and reproduce the risky scenario.
- **From mechanics to observable meaning.** Explain a field, function, or service through the user, state, lifecycle, and protected outcome.
- **From manual rescue to repairing the system.** If an operator had to do work that belongs to the pipeline, restore the pipeline's standard contract and rerun the workflow through it.
- **From a variant to a change of principle.** If a solution is rejected on conceptual grounds, change the boundary or concept instead of rearranging the details of the previous approach.

## Resolving conflicts

| Conflict | Resolution |
|---|---|
| MVP ↔ future | Build the minimum now; protect only expensive invariants, ownership, and public boundaries in advance. |
| KISS ↔ reuse | Generalize a proven rule; keep a local similarity simple. |
| speed ↔ quality | Accelerate independent work and reuse results whose inputs have not changed; preserve the final evidence that addresses the risk. |
| autonomy ↔ control | Make local technical decisions autonomously; explicitly surface a new product decision point or external state change. |
| complete documentation ↔ noise | Record the rationale, decision, invariant, and trigger for evolution; do not retell the implementation. |
| off-the-shelf solution ↔ custom code | Use a mature implementation for a general mechanism; keep the domain rule under your own contract. |

## Output format

State the choice first. Then briefly explain the intent, risk, boundary, deliberately deferred work, and evidence. If information is missing, choose the shortest check with the highest value of information.
