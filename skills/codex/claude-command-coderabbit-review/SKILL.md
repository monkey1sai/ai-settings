---
name: claude-command-coderabbit-review
description: Converted from Claude plugin command "review" (coderabbit). Use when
  the user wants to run this slash-command workflow. CodeRabbit Code Review
---

# Claude Command (Imported): review

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\coderabbit\1.0.0\commands\review.md`
- Plugin: `coderabbit`
- Version: `1.0.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Run CodeRabbit AI code review on your changes
argument-hint: [type] [--base <branch>]
allowed-tools: Bash(coderabbit:*), Bash(cr:*), Bash(git:*)
```

## Original Command Body

# CodeRabbit Code Review

Run an AI-powered code review using CodeRabbit.

## Context

- Current directory: !`pwd`
- Git repo: !`git rev-parse --is-inside-work-tree 2>/dev/null && echo "Yes" || echo "No"`
- Branch: !`git branch --show-current 2>/dev/null || echo "detached HEAD"`
- Has changes: !`git status --porcelain 2>/dev/null | head -1 | grep -q . && echo "Yes" || echo "No"`

## Instructions

Review code based on: **$ARGUMENTS**

### Prerequisites Check

**Skip these checks if you already verified them earlier in this session.**

Otherwise, run:

```bash
coderabbit --version 2>/dev/null && coderabbit auth status 2>&1 | head -3
```

**If CLI not found**, tell user:
> CodeRabbit CLI is not installed. Run in your terminal:
>
> ```bash
> curl -fsSL https://cli.coderabbit.ai/install.sh | sh
> ```
>
> Then restart your shell and try again.

**If "Not logged in"**, tell user:
> You need to authenticate. Run in your terminal:
>
> ```bash
> coderabbit auth login
> ```
>
> Then try again.

### Run Review

Once prerequisites are met:

```bash
coderabbit review --plain -t <type>
```

Where `<type>` from `$ARGUMENTS`:

- `all` (default) - All changes
- `committed` - Committed changes only
- `uncommitted` - Uncommitted only

Add `--base <branch>` if specified.

### Present Results

Group findings by severity:

1. **Critical** - Security, bugs
2. **Suggestions** - Improvements
3. **Positive** - What's good

Offer to apply fixes if `codegenInstructions` are present.
