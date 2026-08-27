# Criteria for a Proven Approach

This skill is based on an in-depth analysis of Codex engineering sessions, including long cycles of design, implementation, review, and improvement of agent processes that were examined in full. It incorporates only approaches that received positive validation, not every observed habit.

## What Counts as Validation

Strong validation:

- the approach recurs across several independent projects;
- the user explicitly approved the result and asked to codify the method in a README, template, skill (`skill`), or shared process;
- the decision passed through implementation, validation, and follow-up review;
- after a process defect was fixed, the corrected process successfully carried the work through the standard path;
- the user stated the rule as a general expected invariant.

Moderate validation:

- the approach was used several times within one long-running cycle;
- it aligns with strongly supported principles but has not yet been transferred across projects;
- the user selected it after comparing alternatives, but the long-term outcome has not been observed.

## How Errors Are Used

A one-off error does not become a rule in the approach. It can yield a useful invariant when the user identifies the defect precisely, generalizes its cause, and the corrected process validates the new rule. For example, manually performing a pipeline duty justifies checking the pipeline contract, but not a permanent ban on all manual actions.

## What Is Excluded

- one-off model settings, `reasoning effort`, and timeout settings;
- a fixed number of agents;
- a mandatory separate Git worktree (`worktree`) for every task;
- a specific CI suite outside its project;
- a one-off force-push or history shape;
- a preference for a particular language, library, or architectural pattern without repeated validation;
- an emotional remark treated as an engineering rule.

## Updating

A new direct correction from the user takes precedence over the profile. Add a new approach after validation through results or repetition; when rules conflict, replace the previous rule instead of accumulating exceptions. Test a substantial update against a realistic design, implementation, and review task.
