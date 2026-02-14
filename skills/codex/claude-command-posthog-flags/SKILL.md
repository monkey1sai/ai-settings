---
name: claude-command-posthog-flags
description: Converted from Claude plugin command "flags" (posthog). Use when the
  user wants to run this slash-command workflow. List and manage PostHog feature flags
---

# Claude Command (Imported): flags

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\posthog\1.0.0\commands\flags.md`
- Plugin: `posthog`
- Version: `1.0.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: List and manage PostHog feature flags
argument-hint: [flag-name]
```

## Original Command Body

# Feature Flags

Use the PostHog MCP tools to help the user with feature flags:

1. First, call `feature-flag-get-all` to list all feature flags in the active project
2. If the user asks about a specific flag, use `feature-flag-get-definition` with the flag key
3. If the user wants to create a flag, use `create-feature-flag`
4. If the user wants to update a flag, use `update-feature-flag`
5. If the user wants to delete a flag, confirm first then use `delete-feature-flag`

## Example prompts

- "Show me all my feature flags"
- "What's the status of the beta-dashboard flag?"
- "Create a new flag called new-onboarding for 50% of users"
- "Turn off the old-checkout flag"
