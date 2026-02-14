---
name: claude-command-posthog-dashboards
description: Converted from Claude plugin command "dashboards" (posthog). Use when
  the user wants to run this slash-command workflow. Manage PostHog dashboards
---

# Claude Command (Imported): dashboards

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\posthog\1.0.0\commands\dashboards.md`
- Plugin: `posthog`
- Version: `1.0.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Manage PostHog dashboards
argument-hint: [dashboard-name]
```

## Original Command Body

# Dashboards

Use the PostHog MCP tools to help the user with dashboard management:

1. To list all dashboards, use `dashboards-get-all`
2. To get details about a specific dashboard, use `dashboard-get` with the dashboard ID
3. To create a new dashboard, use `dashboard-create`
4. To update a dashboard, use `dashboard-update`
5. To add insights to a dashboard, use `add-insight-to-dashboard`
6. To delete a dashboard, confirm first then use `dashboard-delete`

## Example prompts

- "Show me all my dashboards"
- "What insights are on the Marketing dashboard?"
- "Create a new dashboard called Product Metrics"
- "Add the signup funnel insight to the Growth dashboard"
- "Rename my Sales dashboard to Revenue Overview"
