---
name: claude-command-commit-commands-commit
description: Converted from Claude plugin command "commit" (commit-commands). Use
  when the user wants to run this slash-command workflow. Create a git commit
---

# Claude Command (Imported): commit

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\commit-commands\2cd88e7947b7\commands\commit.md`
- Plugin: `commit-commands`
- Version: `2cd88e7947b7`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Create a git commit
```

## Original Command Body

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Based on the above changes, create a single git commit.

You have the capability to call multiple tools in a single response. Stage and create the commit using a single message. Do not use any other tools or do anything else. Do not send any other text or messages besides these tool calls.
