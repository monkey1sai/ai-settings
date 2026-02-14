---
name: claude-command-vercel-deploy
description: Converted from Claude plugin command "deploy" (vercel). Use when the
  user wants to run this slash-command workflow. Deploy the current project to Vercel
---

# Claude Command (Imported): deploy

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\vercel\1.0.0\commands\deploy.md`
- Plugin: `vercel`
- Version: `1.0.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Deploy the current project to Vercel
```

## Original Command Body

# Deploy to Vercel

1. Check prerequisites (`vercel --version`, `vercel whoami`)
2. If not set up, run `vercel login`
3. Run `vercel --prod` for production deployment
4. Display the deployment URL
