---
name: claude-command-posthog-experiments
description: Converted from Claude plugin command "experiments" (posthog). Use when
  the user wants to run this slash-command workflow. Manage PostHog A/B testing experiments
---

# Claude Command (Imported): experiments

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\posthog\1.0.0\commands\experiments.md`
- Plugin: `posthog`
- Version: `1.0.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Manage PostHog A/B testing experiments
argument-hint: [experiment-name]
```

## Original Command Body

# Experiments

Use the PostHog MCP tools to help the user with A/B testing experiments:

1. To list all experiments, use `experiment-get-all`
2. To get details about a specific experiment, use `experiment-get` with the experiment ID
3. To view experiment results and statistical significance, use `experiment-results-get`
4. To create a new experiment, use `experiment-create`
5. To update an experiment, use `experiment-update`
6. To launch or stop an experiment, use the appropriate update action

## Example prompts

- "Show me all my experiments"
- "What are the results of the checkout-flow experiment?"
- "Create an A/B test for the new pricing page"
- "Which variant is winning in the signup-button experiment?"
- "Stop the homepage-hero experiment"
