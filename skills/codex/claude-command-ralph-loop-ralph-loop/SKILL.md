---
name: claude-command-ralph-loop-ralph-loop
description: Converted from Claude plugin command "ralph-loop" (ralph-loop). Use when
  the user wants to run this slash-command workflow. Start Ralph Loop in current session
---

# Claude Command (Imported): ralph-loop

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\ralph-loop\2cd88e7947b7\commands\ralph-loop.md`
- Plugin: `ralph-loop`
- Version: `2cd88e7947b7`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: "Start Ralph Loop in current session"
argument-hint: "PROMPT [--max-iterations N] [--completion-promise TEXT]"
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/scripts/setup-ralph-loop.sh:*)"]
hide-from-slash-command-tool: "true"
```

## Original Command Body

# Ralph Loop Command

Execute the setup script to initialize the Ralph loop:

```!
"${CLAUDE_PLUGIN_ROOT}/scripts/setup-ralph-loop.sh" $ARGUMENTS
```

Please work on the task. When you try to exit, the Ralph loop will feed the SAME PROMPT back to you for the next iteration. You'll see your previous work in files and git history, allowing you to iterate and improve.

CRITICAL RULE: If a completion promise is set, you may ONLY output it when the statement is completely and unequivocally TRUE. Do not output false promises to escape the loop, even if you think you're stuck or should exit for other reasons. The loop is designed to continue until genuine completion.
