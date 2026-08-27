# Agent Orchestration

## When to Delegate

Delegate a concrete, bounded, independent scope that can run in parallel with useful local work. Before starting a new agent, check whether a suitable agent already has the required context.

A new agent is justified for:

- an independent initial assessment;
- a separate subsystem or repository;
- parallel investigation of unrelated hypotheses;
- a task where context isolation improves quality.

Prefer to send fixes back to the original agent for follow-up review. A new group does not replace cross-checking among existing participants.

## Parallelism and Worktrees

- Divide work by independent ownership and outcomes.
- Isolate concurrent changes in separate Git worktrees (`worktree`) when they may actually overlap.
- For sequential integration, use the primary workspace without needlessly multiplying worktrees.
- Before integration, verify dependencies, Git state, target branches, and the cleanliness of each result.

A Git worktree is an isolation tool, not a mandatory ritual.

## Monitoring

For long-running work, track substantive progress. Elapsed time alone says little. A useful status update includes:

- the agent's current step;
- a new artifact or verified fact;
- a deviation that was discovered;
- the deviation's impact on the process;
- the next completion criterion.

Occasionally show the user a shortened version of this status during the session. One to three lines after a substantive change or a long phase without a visible result are usually enough. State the current status first, then the new fact and the nearest next step.

Do not treat an active agent as stuck based on a single fixed timeout when progress is visible. A lack of progress requires diagnosing the state, logs, and blocking condition.

## Supporting Editor

If a long task requires a series of Russian-language status updates or successive editorial passes, one supporting agent may remain active with `$humanizer-ru`:

1. On its first use in the current `turn`, the root agent loads `$humanizer-ru` under the normal rules.
2. The supporting agent reads the skill and required references, receives a bounded editor role for the rest of the current `root-turn`, and does not start its own agents. After each response, it waits for the next draft and finishes when the root agent signals it to stop.
3. While its `turn` remains active, send new drafts through `send_message`. The loaded skill is already in context and does not need to be read again.
4. Send the genre, locked facts, and editing goal with the draft. Request review at substantive checkpoints.
5. Send an urgent short status directly if waiting for the editor would delay feedback. The editor changes presentation; facts, technical decisions, code, and permissions remain with the root agent.

A completed or restarted agent, a new `followup_task`, and a new user `turn` require the skill to be loaded again under the normal rules. A separate agent is usually unnecessary for one short message.

## Issues Discovered

Fix a local defect immediately when the solution is obvious and within scope. Record a recurring or architectural defect as an explicit issue and resolve it through a general mechanism. Preserve findings across steps.

If the orchestrator, a gate (`gate`), or a pipeline (`pipeline`) fails to perform its duty:

1. Do not silently replace it with a manual action.
2. Find the missing contract or check.
3. Fix the mechanism itself.
4. Repeat the standard path and verify that it brings the work to completion.

## Completion

“Continue until completion” means carrying the entire agreed cycle through: execution, monitoring, correction, review, validation, and recording the result. It is a requirement for persistence, not permission to expand the scope or perform unauthorized external actions.
