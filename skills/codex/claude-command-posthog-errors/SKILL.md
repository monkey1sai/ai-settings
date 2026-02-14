---
name: claude-command-posthog-errors
description: Converted from Claude plugin command "errors" (posthog). Use when the
  user wants to run this slash-command workflow. View PostHog error tracking data
---

# Claude Command (Imported): errors

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\posthog\1.0.0\commands\errors.md`
- Plugin: `posthog`
- Version: `1.0.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: View PostHog error tracking data
argument-hint: [error-id]
```

## Original Command Body

# Error Tracking

Use the PostHog MCP tools to help the user with error tracking:

1. To list recent errors, use `list-errors`
2. To get details about a specific error, use `error-details` with the error ID
3. Help the user understand error patterns, frequency, and affected users

## Example prompts

- "What are my most common errors?"
- "Show me errors from the last 24 hours"
- "Tell me more about this error"
- "Which errors are affecting the most users?"
