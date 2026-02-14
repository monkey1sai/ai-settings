---
name: claude-command-notion-create-page
description: Converted from Claude plugin command "create-page" (Notion). Use when
  the user wants to run this slash-command workflow. Create a new Notion page, optionally
  under a specific parent, using the Notion Workspace Skill and Notion MCP server.
---

# Claude Command (Imported): create-page

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\Notion\0.1.0\commands\create-page.md`
- Plugin: `Notion`
- Version: `0.1.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Create a new Notion page, optionally under a specific parent, using the Notion Workspace Skill and Notion MCP server.
argument-hint: "Title of page [optional parent name or ID]"
```

## Original Command Body

You are creating a new Notion page for the user.

Use the Notion Workspace Skill and `notionApi` MCP server to:

1. Parse `$ARGUMENTS` into:
   - Page title
   - Optional parent page/database (if the user mentions a parent)
2. If the parent is ambiguous, ask a brief clarification question before creating the page.
3. Create the page with a sensible default structure based on the title:
   - For "Meeting notes", include sections like Attendees, Agenda, Notes, Action items.
   - For "Project" pages, include sections for Overview, Goals, Timeline, Tasks, Risks.
4. Confirm creation back to the user with:
   - Page title
   - Parent location
   - Link or identifier.

Be careful not to overwrite existing pages. If a page with the exact same name exists in the same parent, confirm with the user whether to reuse it or create a new one.
