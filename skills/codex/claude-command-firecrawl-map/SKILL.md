---
name: claude-command-firecrawl-map
description: Converted from Claude plugin command "map" (firecrawl). Use when the
  user wants to run this slash-command workflow. Discover all URLs on a website
---

# Claude Command (Imported): map

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\firecrawl\1.0.0\commands\map.md`
- Plugin: `firecrawl`
- Version: `1.0.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Discover all URLs on a website
allowed-tools: firecrawl_map
```

## Original Command Body

# Map Website URLs

Use the Firecrawl map tool to discover all accessible URLs on a website.

## When mapping:

1. Take the starting URL from the user
2. Use the `firecrawl_map` tool to discover all pages
3. Present the URL structure in an organized way (by section, type, or hierarchy)
4. Offer to crawl or scrape specific discovered pages

## Options

- `search`: Filter URLs containing specific text
- `limit`: Maximum number of URLs to return (default: 100)
- `sitemap`: How to handle sitemaps - "include", "skip", or "only"
- `includeSubdomains`: Whether to include subdomains
- `ignoreQueryParameters`: Skip URL query parameters

## Use cases

- Understanding site structure before crawling
- Finding specific pages or content types
- Creating sitemaps
- Identifying all pages for comprehensive scraping
- Discovering blog posts, documentation, or product pages
