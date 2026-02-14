---
name: claude-command-posthog-actions
description: Converted from Claude plugin command "actions" (posthog). Use when the
  user wants to run this slash-command workflow. Manage PostHog actions (reusable
  event definitions)
---

# Claude Command (Imported): actions

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\posthog\1.0.0\commands\actions.md`
- Plugin: `posthog`
- Version: `1.0.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Manage PostHog actions (reusable event definitions)
argument-hint: [action-name]
```

## Original Command Body

# Actions

Use the PostHog MCP tools to help the user with actions:

1. To list all actions, use `posthog_actions_get_all`
2. To get details about a specific action, use `posthog_action_get` with the action ID
3. To create a new action, use `posthog_action_create`
4. To update an action, use `posthog_action_update`
5. To delete an action, confirm first then use `posthog_action_delete`

## Example prompts

- "Show me all my actions"
- "Create an action for signup button clicks"
- "What actions track purchases?"
- "Update the newsletter signup action to include email submissions"
- "Delete the old homepage click action"
