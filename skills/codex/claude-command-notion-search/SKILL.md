---
name: claude-command-notion-search
description: Converted from Claude plugin command "search" (Notion). Use when the
  user wants to run this slash-command workflow. Search the user’s Notion workspace
  using the Notion MCP server and Notion Workspace Skill.
---

# Claude Command (Imported): search

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\Notion\0.1.0\commands\search.md`
- Plugin: `Notion`
- Version: `0.1.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Search the user’s Notion workspace using the Notion MCP server and Notion Workspace Skill.
argument-hint: query terms
```

## Original Command Body

Use the Notion Workspace Skill together with the `notionApi` MCP server to search the user's Notion workspace
for content related to `$ARGUMENTS`.

Behavior:

- Interpret `$ARGUMENTS` as a natural-language search query (e.g. "Q1 roadmap", "customer feedback", "bugs triage").
- Prefer fast, high-signal tools such as workspace search or database queries.
- If multiple results are found, summarize them as a short, scannable list, including:
  - Page/database title
  - Type (page, database, task list, etc.)
  - A one-line description or key fields
- If no results are found, suggest refinements or alternative queries.

When you answer, **do not** dump raw JSON. Return a human-readable summary with links/identifiers that the user can click in Notion.
