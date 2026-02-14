---
name: claude-command-commit-commands-commit-push-pr
description: Converted from Claude plugin command "commit-push-pr" (commit-commands).
  Use when the user wants to run this slash-command workflow. Commit, push, and open
  a PR
---

# Claude Command (Imported): commit-push-pr

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\commit-commands\2cd88e7947b7\commands\commit-push-pr.md`
- Plugin: `commit-commands`
- Version: `2cd88e7947b7`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
allowed-tools: Bash(git checkout --branch:*), Bash(git add:*), Bash(git status:*), Bash(git push:*), Bash(git commit:*), Bash(gh pr create:*)
description: Commit, push, and open a PR
```

## Original Command Body

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`

## Your task

Based on the above changes:

1. Create a new branch if on main
2. Create a single commit with an appropriate message
3. Push the branch to origin
4. Create a pull request using `gh pr create`
5. You have the capability to call multiple tools in a single response. You MUST do all of the above in a single message. Do not use any other tools or do anything else. Do not send any other text or messages besides these tool calls.
