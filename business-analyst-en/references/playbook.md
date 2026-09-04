# Business-analysis vocabulary and working artifacts

Apply selectively. The ID scheme below is a local convention when none exists, not a mandatory BABOK or tracker standard.

## Vocabulary

| Term | Working meaning |
| --- | --- |
| Elicitation | Discovering needs through documents, observation, questions, and collaborative analysis; not mechanically transcribing requests. |
| Stakeholder / SME | Interested or affected party / subject-matter expert. Expertise does not necessarily confer approval authority. |
| AS-IS / TO-BE / gap analysis | Current state / target state / analysis of the change needed between them. |
| Business capability / process | What an organization can do / how work moves through activities and roles. |
| BR / SR | Business objective for the change / stakeholder need. |
| FR / NFR | Required solution behavior / measurable qualities and operating conditions. Both are solution requirements. |
| Transition requirement | Temporary transition need: migration, training, coexistence, or business continuity. |
| Business rule / constraint | Domain policy or rule / restriction on permissible solutions. |
| Domain model / glossary | Business entities and relationships / agreed meanings. Neither is a physical database schema. |
| Use case / user story | Scenario for achieving a goal / concise need expressed through actor, need, and value. Both require behavioral detail. |
| Acceptance criteria / UAT | Verifiable conditions for accepting a result / acceptance testing in the business context. |
| Verification / validation | Are requirements stated correctly / are these the right requirements for the business objective? |
| Traceability / RTM | Links to origin, implementation, and verification / a matrix view of those links. |
| Baseline / change request | Agreed reference version / proposal to change it with an impact assessment. |
| Decision table / state model | Business-decision conditions and outcomes / states and allowed transitions. |
| RACI / decision owner | Allocation of responsible, accountable, consulted, and informed roles / authorized owner of a specific decision. Do not appoint them without authority. |
| Scope creep / impact analysis | Uncontrolled scope expansion / assessment of a proposed change’s consequences. |

## IDs and statuses

If no scheme exists, use an initiative prefix: `PAY-BR-001`, `PAY-SR-001`, `PAY-FR-001`, `PAY-NFR-001`, `PAY-TR-001`, `PAY-RULE-001`, `PAY-AC-001`, and `PAY-CR-001`. Link existing product objective IDs to BRs without duplicating the objective. Do not renumber IDs when changing their order.

Keep two axes separate: requirement status (`draft / in-review / approved / superseded`) and implementation evidence (`not-checked / planned / implemented / verified`). Provide evidence for approved and verified states. Implemented but unapproved behavior is possible; do not conceal that combination.

## Requirement card

```text
ID / version / type / requirement status:
Statement:
Business objective / rationale:
Source / date or version / authority:
Owner / approver (or unassigned):
Priority and rationale:
Scope / preconditions / trigger:
Main behavior / exceptions / postconditions:
Related RULE-IDs / requirements / constraints:
AC-IDs and verification method:
Implementation evidence / links to actual tests:
TBD: parameter, impact, proposed owner:
```

## Requirements traceability matrix

| BR or OBJ | SR | FR/NFR/TR | RULE / scenario | AC | Verification | Status / evidence |
| --- | --- | --- | --- | --- | --- | --- |
| ID | ID | ID | ID or justified N/A | ID | link or planned | actual status |

## Process and decision table

```text
Process: boundary / owner / trigger / input / output:
AS-IS: step → role → data → rule → exception:
TO-BE: step → role → data → rule → exception:
Gap: change → rationale → dependency → question:
Decision table: conditions → outcome → RULE-ID:
Table checks: coverage / overlap / conflict / default:
State table: source state → event → guard → target state / rejection:
```

## Change impact and UAT

```text
CR-ID / baseline / requester / rationale:
Changed requirements and rules:
Impact on processes, roles, data, integrations, and migration:
Impact on ACs, tests, training, rollout, and documentation:
Options / risks / estimates with sources:
Decision / approver / evidence / new baseline version:

UAT-ID / business scenario / objective and ACs:
Role / preconditions / synthetic data:
Actions / expected business result:
Actual result / evidence / deviations:
Accepting party / decision or pending:
```

## Synthetic example: request cancellation

This teaching example proposes, but does not approve, two rules: `PAY-RULE-001` allows an owner to cancel a request only in `Draft`; `PAY-RULE-002` returns the existing state on a repeated cancellation without repeating its effects. A real project must confirm these rules separately.

Proposed `PAY-FR-001`: “When an owner requests cancellation of a request in Draft, the system changes its state to Cancelled and makes the result available to the owner.”

```gherkin
Scenario: Owner cancels a draft
  Given the request belongs to the user and is in Draft
  When the owner requests cancellation
  Then the request is in Cancelled
  And the owner receives a cancellation confirmation

Scenario: Repeated cancellation
  Given the owner's request is already in Cancelled
  When the owner requests cancellation again
  Then the request remains in Cancelled
  And no new cancellation side effects occur
```

Before handoff, also address another owner’s request, other states, and concurrent state changes. “Do not repeat effects” specifies observable behavior; architecture chooses the idempotency mechanism.
