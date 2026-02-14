---
name: claude-command-posthog-logs
description: Converted from Claude plugin command "logs" (posthog). Use when the user
  wants to run this slash-command workflow. Query PostHog logs and log attributes
---

# Claude Command (Imported): logs

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\posthog\1.0.0\commands\logs.md`
- Plugin: `posthog`
- Version: `1.0.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Query PostHog logs and log attributes
argument-hint: [query]
```

## Original Command Body

# Logs

Use the PostHog MCP tools to help the user with log querying:

1. To query logs, use `logs-query` with optional filters for time range, severity, and content
2. To discover available log attributes, use `logs-list-attributes`
3. To see possible values for a specific attribute, use `logs-list-attribute-values`
4. Help the user filter and analyze logs to debug issues

## Example prompts

- "Show me logs from the last hour"
- "Find error logs containing 'timeout'"
- "What log attributes are available?"
- "Show me warning logs from the auth service"
