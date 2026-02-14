---
name: claude-command-posthog-insights
description: Converted from Claude plugin command "insights" (posthog). Use when the
  user wants to run this slash-command workflow. Query PostHog analytics and insights
---

# Claude Command (Imported): insights

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\posthog\1.0.0\commands\insights.md`
- Plugin: `posthog`
- Version: `1.0.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Query PostHog analytics and insights
argument-hint: [query]
```

## Original Command Body

# Insights

Use the PostHog MCP tools to help the user with insights and analytics:

1. To list existing insights, use `insights-get-all`
2. To view a specific insight, use `insight-get` with the insight ID
3. To run a custom query, use `insight-query` or `query-run`
4. For natural language questions, use `query-generate-hogql-from-question` to convert to HogQL first
5. To create new insights, use `insight-create-from-query`

## Example prompts

- "Show me my top insights"
- "How many users signed up last week?"
- "What's the conversion rate for the checkout funnel?"
- "Create an insight showing daily active users"
