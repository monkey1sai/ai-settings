---
name: claude-command-vercel-setup
description: Converted from Claude plugin command "setup" (vercel). Use when the user
  wants to run this slash-command workflow. Set up Vercel CLI and configure the project
---

# Claude Command (Imported): setup

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\vercel\1.0.0\commands\setup.md`
- Plugin: `vercel`
- Version: `1.0.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Set up Vercel CLI and configure the project
```

## Original Command Body

# Vercel Setup

1. Check/install Vercel CLI (`npm install -g vercel`)
2. Authenticate with `vercel login`
3. Link project with `vercel link`
4. Review environment variables with `vercel env ls`
