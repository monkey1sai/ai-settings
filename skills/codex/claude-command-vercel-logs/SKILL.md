---
name: claude-command-vercel-logs
description: Converted from Claude plugin command "logs" (vercel). Use when the user
  wants to run this slash-command workflow. View deployment logs from Vercel
---

# Claude Command (Imported): logs

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\vercel\1.0.0\commands\logs.md`
- Plugin: `vercel`
- Version: `1.0.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: View deployment logs from Vercel
```

## Original Command Body

# View Vercel Logs

1. Run `vercel ls` to list recent deployments
2. Fetch logs with `vercel logs <deployment-url>`
3. Use `--follow` to stream logs in real-time
4. Analyze and report any errors found
