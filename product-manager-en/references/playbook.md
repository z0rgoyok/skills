# Product vocabulary and working artifacts

Use only the sections needed for the current decision. Templates are scaffolding, not permission to fill unknowns with invented data.

## Vocabulary

| Term | Working meaning |
| --- | --- |
| Problem space / solution space | Needs and obstacles / ways to address them. Do not jump to the latter without the former. |
| Discovery / delivery | Reducing uncertainty about value and solutions / building and shipping a solution. |
| JTBD | Progress a person seeks in a particular situation, not a feature name. |
| ICP / segment | Profile of a best-fit customer / group sharing meaningful needs and behavior. |
| Value proposition | For whom we create what value, compared with which alternative. |
| Opportunity | A chance to influence an outcome through a need, pain, or desired progress. |
| Outcome / output / impact | Change in behavior or results / shipped artifact / broader effect on the business or people. |
| North Star Metric / input metrics | Measure of sustainably delivered value / controllable factors influencing it. Do not assign an NSM mechanically. |
| Activation / retention / churn | Reaching first meaningful value / returning or remaining active / attrition. Always define the event, cohort, and period. |
| Leading / lagging indicators | Early signals / observed end results. Their relationship needs validation. |
| Guardrail | A constraint on what must not deteriorate while improving the primary metric. |
| MVP / MLP | Smallest test of value / emphasis on a minimally lovable experience. Neither term replaces explicit scope. |
| RICE | Reach, Impact, Confidence, Effort. Ranking supports a decision discussion; it does not prove objectivity. |
| Opportunity cost / cost of delay | Value of a forgone alternative / consequences of postponing a decision. |
| Unit economics | Revenue and costs per agreed unit; define contribution margin and included costs. |
| LTV / CAC / payback | Customer value over a relationship / acquisition cost / recovery period. Align definitions, cohorts, and calculation bases. |
| Pricing / packaging / GTM | Price / composition of offers and tiers / approach to reaching the selected market and buyer. |
| Roadmap / backlog | Sequence of intentions and outcomes / ordered work. A roadmap is not a promise of every date. |
| Product-market fit | Sustained alignment with demand in the chosen market; one metric alone does not establish it. |

## Decision brief / compact PRD

```text
Initiative / version / status / decision owner:
Decision required:
Recommendation and rationale:
Segment, user, buyer:
Problem / JTBD / current alternative:
Evidence: source, date, observation, limitation:
Assumptions and falsification conditions:
Outcome / metric definition / baseline / proposed target / horizon:
Guardrails:
Options: no change / minimal / expanded; trade-offs:
MVP and key end-to-end scenario:
In scope / out of scope:
Dependencies, constraints, and estimates with owners:
Rollout / rollback / support readiness:
Open decisions: question, impact, proposed owner:
Next step and completion criterion:
```

## Experiment card

```text
HYP-ID / hypothesis / segment / mechanism:
Riskiest assumption:
Method and why it fits:
Observation unit; for A/B, randomization unit:
Primary metric / baseline / minimum meaningful effect:
Sample: available data, calculation, or missing inputs:
Observation window / budget / guardrails / stop criteria:
Decision on success / failure / inconclusive result:
Bias risks and causal-inference limitations:
Result: planned / running / completed; evidence:
```

## Handoff to BA and architecture

Provide the initiative ID, problem statement, segment, objective and metric definition, evidence, product decisions, in/out of scope, key scenarios, constraints, and open questions. Receive gaps, conflicting rules, dependencies, and cost and scope implications. Record scope changes as a new decision version rather than a silent edit.

Working loop: `PM: intention → BA: specification → architect: feasibility → PM: scope trade-off`. This is an accountability route, not an instruction to launch agents automatically. For disagreements, record positions and missing evidence, then escalate to the authorized decision owner; do not simulate consensus.

## Synthetic example

Request: “Add an AI chat to the service.”

Weak result: a list of chat screens and an invented 20% retention improvement.

Strong result: “First identify the segment and task where users lose time. Hypothesis: in-context assistance reduces time to the first successful result. The baseline is not measured. Compare the current flow, improved guidance, and concierge assistance; propose a pilot measuring completion rate, time-to-value, cost per successful case, and errors. Choose product scope from the result, not the technology’s appeal.”
