# Architectural Approach

## From Domain to Structure

First reconstruct the shared vocabulary, entities, states, lifecycle, and product commitments. Only then define the module, data, and API boundaries. A technical name does not replace a domain explanation.

## Ownership and the Source of Truth

- Every mutable rule, state, and transition must have one explicit owner.
- Duplicated knowledge is more dangerous than similar lines of code: look for a replicated invariant, not identical syntax.
- A consumer receives the projection or contract it needs and does not directly read another module's internal state.
- Cross-cutting coordination must not blur the responsibilities of several modules into one shallow service.

## Module Depth

A good boundary hides a complex solution behind a small, stable interface. Extraction is justified when:

- the rule already recurs or has a confirmed second consumer;
- the parts change for different reasons;
- a separate module protects a domain invariant;
- without the boundary, a future data, security, or lifecycle migration would become painful.

A small amount of code does not preclude a deep module. A large amount of code does not prove that a new layer is necessary.

A test exercises public behavior, but it is not by itself a second real consumer of an application abstraction. A future feature without an approved plan also does not justify generalization; it can justify only a clear extensibility boundary.

## Evolutionary MVP

Separate decisions into two classes:

1. **Expensive to change:** data ownership, public contracts, identity, authorization, idempotency, write boundaries, compatibility, and failure behavior. Establish their minimum invariant now.
2. **Reversible:** the specific technology, physical placement, optimization, replica count, and the adapter's internal shape. Defer them until a measurable trigger appears.

Represent a future capability as an extensibility boundary (`seam`) and a condition for evolving it. Do not implement speculative extensibility without a consumer.

## Operational Validation

For an architectural decision, identify:

- the normal load or failure scenario;
- the limit of the current model;
- the consequence of violating the boundary;
- the minimum protection needed now;
- the signal that will make the next step necessary.

Prioritize frequent and plausible scenarios. A rare edge case affects the MVP only when its potential harm makes the risk material.

## Off-the-Shelf and Custom

Prefer the standard library or a mature tool for a general mechanism when it is maintained and fits the task. Keep a product-defining domain rule in its own module and verify it as an explicit contract. A solution's popularity is not an argument when its requirements do not match.

## Change Safety

Prefer narrow permissions, explicit ownership, and reversible operations. `Production` changes, data migrations, publishing, and other material external changes require a confirmed verification and recovery plan, as well as authorization within the current task.
