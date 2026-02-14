---
name: claude-command-notion-database-query
description: Converted from Claude plugin command "database-query" (Notion). Use when
  the user wants to run this slash-command workflow. Query a Notion database by name
  or ID and return structured, readable results.
---

# Claude Command (Imported): database-query

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\Notion\0.1.0\commands\database-query.md`
- Plugin: `Notion`
- Version: `0.1.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Query a Notion database by name or ID and return structured, readable results.
argument-hint: 'database name or ID; filters (optional)'
```

## Original Command Body

You are querying a Notion database on the user's behalf.

Use the Notion Workspace Skill and `notionApi` MCP server to:

1. Interpret `$ARGUMENTS` as:
   - Target database (by name or ID)
   - Optional filter(s) or sort(s) the user describes.
2. If multiple databases match the name, ask the user to choose the correct one.
3. Perform a query that:
   - Applies the requested filters (e.g. status = Active, owner = Alice, due date this week).
   - Limits to a reasonable number of rows (e.g. 20–50) unless the user explicitly asks for more.
4. Present the results in a compact table-like format with:
   - Key properties (e.g. Name, Status, Owner, Due).
   - A short summary if the database has rich text content.
5. If no rows match, say so clearly and suggest alternative filters.

Avoid dumping raw JSON. Focus on readability and decision-making value for the user.
