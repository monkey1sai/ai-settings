---
name: claude-command-posthog-query
description: Converted from Claude plugin command "query" (posthog). Use when the
  user wants to run this slash-command workflow. Run HogQL queries and natural language
  analytics
---

# Claude Command (Imported): query

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\posthog\1.0.0\commands\query.md`
- Plugin: `posthog`
- Version: `1.0.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Run HogQL queries and natural language analytics
argument-hint: [question or query]
```

## Original Command Body

# Query

Use the PostHog MCP tools to run HogQL queries and answer analytics questions:

1. For natural language questions, use `query-generate-hogql-from-question` to convert to HogQL
2. To run a HogQL query directly, use `query-run`
3. For complex analysis, combine multiple queries to build up the answer
4. Use `insight-query` to query data in the context of an existing insight

## HogQL Tips

- HogQL is PostHog's SQL-like query language
- Common tables: `events`, `persons`, `sessions`, `groups`
- Use `properties.$property_name` to access event properties
- Use `person.properties.$property_name` to access person properties

## Example prompts

- "How many users signed up last week?"
- "What's my most triggered event?"
- "Show me the top 10 pages by pageviews"
- "Run this query: SELECT count() FROM events WHERE event = 'purchase'"
- "What countries are my users from?"
