---
name: claude-command-notion-find
description: Converted from Claude plugin command "find" (Notion). Use when the user
  wants to run this slash-command workflow. Quickly find pages or databases in Notion
  by title keywords.
---

# Claude Command (Imported): find

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\Notion\0.1.0\commands\find.md`
- Plugin: `Notion`
- Version: `0.1.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Quickly find pages or databases in Notion by title keywords.
argument-hint: query terms
```

## Original Command Body

Use the Notion Workspace Skill and `notionApi` MCP server to quickly locate pages or databases whose titles
match `$ARGUMENTS`.

Behavior:

- Treat `$ARGUMENTS` as fuzzy search terms for titles (e.g. "Q1 plan", "Claude marketplace spec").
- Search both:
  - Individual pages
  - Databases
- Return a short list of the best matches with:
  - Title
  - Type (page or database)
  - Location / parent (if available)
- Prefer precision over recall: better to show 5–10 very relevant results than 50 noisy ones.

If nothing is found, say so clearly and suggest alternate search terms.
