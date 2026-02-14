---
name: claude-command-posthog-surveys
description: Converted from Claude plugin command "surveys" (posthog). Use when the
  user wants to run this slash-command workflow. Manage PostHog surveys
---

# Claude Command (Imported): surveys

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\posthog\1.0.0\commands\surveys.md`
- Plugin: `posthog`
- Version: `1.0.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Manage PostHog surveys
argument-hint: [survey-name]
```

## Original Command Body

# Surveys

Use the PostHog MCP tools to help the user with survey management:

1. To list all surveys, use `surveys-get-all`
2. To get details about a specific survey, use `survey-get` with the survey ID
3. To view survey responses and statistics, use `survey-stats`
4. To create a new survey, use `survey-create`
5. To update a survey, use `survey-update`
6. To launch or stop a survey, use the appropriate update action

## Example prompts

- "Show me all my surveys"
- "What are the responses to the NPS survey?"
- "Create a feedback survey for the checkout page"
- "How many people completed the onboarding survey?"
- "Stop the beta feedback survey"
