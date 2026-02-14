---
name: claude-command-ralph-loop-cancel-ralph
description: Converted from Claude plugin command "cancel-ralph" (ralph-loop). Use
  when the user wants to run this slash-command workflow. Cancel active Ralph Loop
---

# Claude Command (Imported): cancel-ralph

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\ralph-loop\2cd88e7947b7\commands\cancel-ralph.md`
- Plugin: `ralph-loop`
- Version: `2cd88e7947b7`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: "Cancel active Ralph Loop"
allowed-tools: ["Bash(test -f .claude/ralph-loop.local.md:*)", "Bash(rm .claude/ralph-loop.local.md)", "Read(.claude/ralph-loop.local.md)"]
hide-from-slash-command-tool: "true"
```

## Original Command Body

# Cancel Ralph

To cancel the Ralph loop:

1. Check if `.claude/ralph-loop.local.md` exists using Bash: `test -f .claude/ralph-loop.local.md && echo "EXISTS" || echo "NOT_FOUND"`

2. **If NOT_FOUND**: Say "No active Ralph loop found."

3. **If EXISTS**:
   - Read `.claude/ralph-loop.local.md` to get the current iteration number from the `iteration:` field
   - Remove the file using Bash: `rm .claude/ralph-loop.local.md`
   - Report: "Cancelled Ralph loop (was at iteration N)" where N is the iteration value
