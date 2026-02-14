---
name: claude-command-posthog-workspace
description: Converted from Claude plugin command "workspace" (posthog). Use when
  the user wants to run this slash-command workflow. Manage PostHog organizations,
  projects, and view event/property definitions
---

# Claude Command (Imported): workspace

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\posthog\1.0.0\commands\workspace.md`
- Plugin: `posthog`
- Version: `1.0.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Manage PostHog organizations, projects, and view event/property definitions
argument-hint: [org-or-project]
```

## Original Command Body

# Workspace

Use the PostHog MCP tools to help the user with organizations, projects, and definitions:

## Organizations

1. To list all organizations, use `posthog_organizations_get`
2. To switch to a different organization, use `posthog_switch_organization`
3. To get details about the current organization, use `posthog_organization_details_get`

## Projects

1. To list all projects in the current organization, use `posthog_projects_get`
2. To switch to a different project, use `posthog_switch_project`

## Event and Property Definitions

1. To list all event definitions, use `posthog_event_definitions_list`
2. To list all properties (or properties for a specific event), use `posthog_properties_list`

## Example prompts

- "What organizations do I have access to?"
- "Switch to the production project"
- "List all event definitions"
- "What properties are available for the signup event?"
- "Show me details about the current organization"
- "What projects are in this organization?"
