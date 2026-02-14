---
name: claude-command-stripe-test-cards
description: Converted from Claude plugin command "test-cards" (stripe). Use when
  the user wants to run this slash-command workflow. Display Stripe test card numbers
  for various testing scenarios
---

# Claude Command (Imported): test-cards

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\stripe\0.1.0\commands\test-cards.md`
- Plugin: `stripe`
- Version: `0.1.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Display Stripe test card numbers for various testing scenarios
argument-hint: [scenario]
```

## Original Command Body

# Test Cards Reference

Provide a quick reference for Stripe test card numbers:

1. If a scenario argument is provided (e.g., "declined", "3dsecure", "fraud"), show relevant test cards for that scenario
2. Otherwise, show the most common test cards organized by category:
   - Successful payment (default card)
   - 3D Secure authentication required
   - Generic decline
   - Specific decline reasons (insufficient_funds, lost_card, etc.)
3. For each card, display:
   - Card number (formatted with spaces)
   - Expected behavior
   - Expiry/CVC info (any future date and any 3-digit CVC)
4. Use clear visual indicators (✓ for success, ⚠️ for auth required, ✗ for decline)
5. Mention that these only work in test mode
6. Provide link to full testing documentation: https://docs.stripe.com/testing.md

If the user is currently working on test code, offer to generate test cases using these cards.
