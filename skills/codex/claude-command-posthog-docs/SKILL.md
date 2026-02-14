---
name: claude-command-posthog-docs
description: Converted from Claude plugin command "docs" (posthog). Use when the user
  wants to run this slash-command workflow. Search PostHog documentation
---

# Claude Command (Imported): docs

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\posthog\1.0.0\commands\docs.md`
- Plugin: `posthog`
- Version: `1.0.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Search PostHog documentation
argument-hint: [search-query]
```

## Original Command Body

# Documentation

Use the PostHog MCP tools to help the user find information in PostHog docs:

1. To search the documentation, use `docs-search` with the user's query
2. Return relevant documentation links and summaries
3. Help explain PostHog concepts and features based on the docs

## Example prompts

- "How do I set up feature flags?"
- "What is HogQL?"
- "How do I track custom events?"
- "Explain how session replay works"
