---
name: claude-command-posthog-search
description: Converted from Claude plugin command "search" (posthog). Use when the
  user wants to run this slash-command workflow. Search across all PostHog entities
---

# Claude Command (Imported): search

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\posthog\1.0.0\commands\search.md`
- Plugin: `posthog`
- Version: `1.0.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Search across all PostHog entities
argument-hint: <search-term>
```

## Original Command Body

# Search

Use the PostHog MCP tools to help the user search across all entities:

1. To search across all PostHog entities (insights, dashboards, feature flags, experiments, actions, cohorts, etc.), use `posthog_entity_search`

## Example prompts

- "Search for anything related to checkout"
- "Find all dashboards mentioning revenue"
- "Search for signup-related insights"
- "What entities reference the purchase event?"
- "Find everything related to onboarding"
