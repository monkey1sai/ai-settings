---
name: claude-command-firecrawl-crawl
description: Converted from Claude plugin command "crawl" (firecrawl). Use when the
  user wants to run this slash-command workflow. Crawl an entire website and extract
  content from multiple pages
---

# Claude Command (Imported): crawl

- Source: `C:\Users\monke\.claude\plugins\cache\claude-plugins-official\firecrawl\1.0.0\commands\crawl.md`
- Plugin: `firecrawl`
- Version: `1.0.0`

## Notes

- Claude command files may use `!` prefixes for shell execution. In Codex, run those commands in the terminal manually.

## Original Command Frontmatter (Reference)

```yaml
description: Crawl an entire website and extract content from multiple pages
allowed-tools: firecrawl_crawl, firecrawl_check_crawl_status
```

## Original Command Body

# Crawl Website

Use the Firecrawl crawl tool to extract content from multiple pages of a website.

## Important: Auto-poll for completion

Crawl operations are asynchronous. When you start a crawl:
1. You'll receive an operation ID
2. **Automatically** call `firecrawl_check_crawl_status` with that ID
3. Keep checking until status is "completed" or "failed"
4. Return the final results to the user

Do NOT ask the user to check status manually - handle it automatically.

## When crawling:

1. Ask the user for the starting URL if not provided
2. Clarify the scope: how many pages, specific sections, or entire site
3. Use the `firecrawl_crawl` tool with appropriate parameters
4. Poll for completion using `firecrawl_check_crawl_status`
5. Summarize the crawled content and provide structured results

## Available Formats

Same as scrape - you can request:
- `markdown`, `html`, `rawHtml`, `screenshot`, `links`, `summary`

## Options

- `maxDepth`: How deep to crawl (default: 2)
- `limit`: Maximum number of pages to crawl
- `allowExternalLinks`: Whether to follow external links
- `includePaths`: URL patterns to include
- `excludePaths`: URL patterns to exclude
- `deduplicateSimilarURLs`: Skip similar URLs

## Tips

- Consider using the `/map` command first to discover available URLs
- Set reasonable limits to avoid long wait times
- Use `includePaths` to focus on specific sections
