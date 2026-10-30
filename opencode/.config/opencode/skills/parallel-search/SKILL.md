---
name: parallel-search
description: Use ONLY when the user asks you to search the web for information. Run websearch (or web_search tool) AND ddgr <query> in parallel as independent bash calls, then use webfetch to fetch individual result URLs from either source. Always batch all three tool types into a single message whenever possible to maximize parallelism.
---

# Parallel Search

When the user issues a search query, always use **all available search tools concurrently** in a single tool-call message:

1. **`websearch`** — for structured web results via the configured search provider.
2. **`ddgr`** — CLI DuckDuckGo search (installed at `/usr/bin/ddgr`), run via `bash` with `ddgr --num 5 <query>` or similar. Pipe results back. If ddgr is interactive (`less`), use `ddgr -n 5 <query>` to suppress paging.
3. **`webfetch`** — after results arrive, fetch individual URLs from the combined result set in parallel.

## Procedure

When you see a search request:

- Launch `websearch` and `ddgr` in **parallel** (same message, multiple tool calls).
- Collect all result URLs from both sources.
- Use `webfetch` to fetch the most relevant pages in parallel.
- Present a synthesized answer from all sources.

Do NOT run ddgr + websearch sequentially — parallelism is the point of this skill.
