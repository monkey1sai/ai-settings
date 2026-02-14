---
name: claude-command-stripe-explain-error
description: Converted from Claude plugin command "explain-error" (stripe). Use when
  the user wants to run this slash-command workflow. Explain Stripe error codes and
  provide solutions with code examples
---

# Claude Command (Imported): explain-error

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\stripe\0.1.0\commands\explain-error.md`
- Plugin: `stripe`
- Version: `0.1.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Explain Stripe error codes and provide solutions with code examples
argument-hint: [error_code or error_message]
```

## Original Command Body

# Explain Stripe Error

Provide a comprehensive explanation of the given Stripe error code or error message:

1. Accept the error code or full error message from the arguments
2. Explain in plain English what the error means
3. List common causes of this error
4. Provide specific solutions and handling recommendations
5. Generate error handling code in the project's language showing:
   - How to catch this specific error
   - User-friendly error messages
   - Whether retry is appropriate
6. Mention related error codes the developer should be aware of
7. Include a link to the relevant Stripe documentation

Focus on actionable solutions and production-ready error handling patterns.
