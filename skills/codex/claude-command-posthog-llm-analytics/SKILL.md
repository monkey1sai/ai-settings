---
name: claude-command-posthog-llm-analytics
description: Converted from Claude plugin command "llm-analytics" (posthog). Use when
  the user wants to run this slash-command workflow. Track LLM and AI costs in PostHog
---

# Claude Command (Imported): llm-analytics

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\posthog\1.0.0\commands\llm-analytics.md`
- Plugin: `posthog`
- Version: `1.0.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Track LLM and AI costs in PostHog
argument-hint: [time-range]
```

## Original Command Body

# LLM Analytics

Use the PostHog MCP tools to help the user with LLM and AI cost tracking:

1. To get LLM costs and usage data, use `get-llm-total-costs-for-project`
2. Help the user understand their AI spending by model, prompt, or time period
3. Identify expensive prompts and opportunities for optimization

## Example prompts

- "What are my LLM costs this week?"
- "Show me AI usage by model"
- "Which prompts are most expensive?"
- "How much have I spent on GPT-4 this month?"
