---
name: claude-command-notion-create-database-row
description: Converted from Claude plugin command "create-database-row" (Notion).
  Use when the user wants to run this slash-command workflow. Insert a new row into
  a specified Notion database using natural-language property values.
---

# Claude Command (Imported): create-database-row

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\Notion\0.1.0\commands\create-database-row.md`
- Plugin: `Notion`
- Version: `0.1.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Insert a new row into a specified Notion database using natural-language property values.
argument-hint: 'database name or ID; key=value properties'
```

## Original Command Body

You are inserting a new row into a Notion database.

Use the Notion Workspace Skill and `notionApi` MCP server to:

1. Interpret `$ARGUMENTS` as:
   - Target database (by name or ID)
   - A set of properties expressed as `key=value` pairs (e.g. "Severity=High Owner=Alice Status=Open").
2. Resolve the database:
   - If multiple matches, ask the user to choose.
3. Map the provided keys to the database’s actual property names, handling minor naming differences.
4. Validate required properties:
   - If a required property is missing, ask the user for the value before creating the row.
5. Create the row and confirm with:
   - The resolved database name
   - The new row’s key properties
   - A link or identifier.

Be robust to capitalization and spacing in property names. Explain any properties you had to infer or skip.
