---
name: claude-command-notion-create-task
description: Converted from Claude plugin command "create-task" (Notion). Use when
  the user wants to run this slash-command workflow. Create a new task in the user’s
  Notion tasks database with sensible defaults.
---

# Claude Command (Imported): create-task

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\Notion\0.1.0\commands\create-task.md`
- Plugin: `Notion`
- Version: `0.1.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Create a new task in the user’s Notion tasks database with sensible defaults.
argument-hint: 'task title; optional due date, status, owner, project'
```

## Original Command Body

You are creating a new task for the user in Notion.

Use the Notion Workspace Skill and `notionApi` MCP server to:

1. Interpret `$ARGUMENTS` as:
   - Task title (required)
   - Optional due date
   - Optional status
   - Optional owner/assignee
   - Optional project or related page
2. Identify the appropriate "Tasks" database:
   - Prefer a database whose name or description clearly indicates tasks/todo items.
   - If more than one candidate exists, ask the user to choose.
3. Create a new row with:
   - Title set to the task title.
   - Due date, Status, Owner, Project, or similar properties mapped when available.
4. Confirm creation by returning:
   - Task title
   - Key properties
   - Link or identifier.

If required properties are missing or the tasks database cannot be confidently identified, ask a concise clarification question before making changes.
