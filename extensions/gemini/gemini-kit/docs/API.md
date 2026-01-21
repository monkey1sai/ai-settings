# Gemini-Kit API Reference

Complete documentation for all MCP tools provided by gemini-kit.

---

## Table of Contents

- [Core Tools](#core-tools)
  - [kit_create_checkpoint](#kit_create_checkpoint)
  - [kit_restore_checkpoint](#kit_restore_checkpoint)
  - [kit_list_checkpoints](#kit_list_checkpoints)
  - [kit_get_project_context](#kit_get_project_context)
  - [kit_handoff_agent](#kit_handoff_agent)
  - [kit_save_artifact](#kit_save_artifact)
- [Knowledge Tools](#knowledge-tools)
  - [kit_save_learning](#kit_save_learning)
  - [kit_get_learnings](#kit_get_learnings)
  - [kit_store_diff](#kit_store_diff)
  - [kit_apply_stored_diff](#kit_apply_stored_diff)
  - [kit_index_codebase](#kit_index_codebase)
  - [kit_keyword_search](#kit_keyword_search)
- [Team Orchestration Tools](#team-orchestration-tools)
  - [kit_team_start](#kit_team_start)
  - [kit_team_status](#kit_team_status)
  - [kit_team_end](#kit_team_end)
  - [kit_run_workflow](#kit_run_workflow)
  - [kit_smart_route](#kit_smart_route)
  - [kit_list_workflows](#kit_list_workflows)
  - [kit_session_history](#kit_session_history)

---

## Core Tools

### kit_create_checkpoint

Create a git checkpoint before making changes. Allows for easy rollback.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `name` | string | Yes | Descriptive name for the checkpoint |
| `includeUntracked` | boolean | No | Include untracked files (default: false) |

**Returns:**
- `checkpointId`: Unique identifier for rollback
- `branch`: Name of the backup branch created
- `commitHash`: Git commit hash

**Example:**
```json
{
  "name": "before-refactor-auth",
  "includeUntracked": true
}
```

---

### kit_restore_checkpoint

Restore the codebase to a previous checkpoint state.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `checkpointId` | string | Yes | ID from `kit_create_checkpoint` |

**Returns:**
- Success message with restored state details

**Example:**
```json
{
  "checkpointId": "chk-1702656000000"
}
```

---

### kit_list_checkpoints

List all available checkpoints for the current project.

**Parameters:** None

**Returns:**
- Array of checkpoints with ID, name, timestamp, and commit info

---

### kit_get_project_context

Gather comprehensive project context including structure, dependencies, and recent changes.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `depth` | number | No | Directory depth to scan (default: 2) |

**Returns:**
- `structure`: File/directory tree
- `package`: Package info (if package.json exists)
- `recentCommits`: Last 5 git commits

---

### kit_handoff_agent

Transfer context from one agent to another in a workflow.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `fromAgent` | string | Yes | Current agent name |
| `toAgent` | string | Yes | Target agent name |
| `context` | string | Yes | Context to pass |
| `artifacts` | string[] | No | File paths of related artifacts |

**Example:**
```json
{
  "fromAgent": "planner",
  "toAgent": "coder",
  "context": "Plan complete. Implement auth module with JWT.",
  "artifacts": [".gemini-kit/artifacts/plan/auth-plan.md"]
}
```

---

### kit_save_artifact

Save an artifact (plan, report, log) from agent work.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `name` | string | Yes | Artifact name |
| `type` | enum | Yes | `plan`, `report`, `log`, or `other` |
| `content` | string | Yes | Artifact content (markdown) |

**Returns:**
- File path where artifact was saved

---

## Knowledge Tools

### kit_save_learning

Save a learning from user feedback to improve future responses.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `category` | enum | Yes | `code_style`, `bug`, `preference`, `pattern`, `other` |
| `lesson` | string | Yes | The lesson learned |
| `context` | string | No | Additional context |

**Example:**
```json
{
  "category": "code_style",
  "lesson": "User prefers arrow functions over regular functions",
  "context": "Applies to all JavaScript/TypeScript files"
}
```

---

### kit_get_learnings

Retrieve learnings with optional semantic search.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `query` | string | No | Search query for relevant learnings |
| `category` | string | No | Filter by category |
| `limit` | number | No | Max results (default: 5) |

**Example:**
```json
{
  "query": "typescript arrow functions",
  "limit": 3
}
```

---

### kit_store_diff

Store a proposed diff for later application (Dry Run mode).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `file` | string | Yes | File path |
| `originalContent` | string | Yes | Original file content |
| `newContent` | string | Yes | Proposed new content |
| `description` | string | No | Change description |

**Returns:**
- `diffId`: ID for later application
- Unified diff preview

---

### kit_apply_stored_diff

Apply a previously stored diff with conflict detection.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `diffId` | string | Yes | Diff ID from `kit_store_diff` |
| `force` | boolean | No | Force apply despite conflicts (DANGEROUS) |

**Returns:**
- Success/failure with conflict details if any

---

### kit_index_codebase

Index the codebase for keyword-based search.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `extensions` | string[] | No | File extensions (default: ['.ts', '.js', '.py', ...]) |
| `maxFiles` | number | No | Maximum files to index (default: 100) |

**Returns:**
- Number of files indexed
- Top files by size

---

### kit_keyword_search

Search indexed codebase by keywords, function names, or file names.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `query` | string | Yes | Search query |
| `limit` | number | No | Max results (default: 10) |

**Returns:**
- Ranked search results with file, functions, classes, and score

---

## Team Orchestration Tools

### kit_team_start

Start a new team session with a goal.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `goal` | string | Yes | The goal/task for the session |
| `sessionName` | string | No | Optional session name |

**Returns:**
- Session details
- Suggested workflow based on goal
- List of all available workflows

---

### kit_team_status

Get current team session status and progress.

**Parameters:** None

**Returns:**
- Session summary
- Completed steps
- Current agent

---

### kit_team_end

End the current team session.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `status` | enum | No | `completed` or `failed` (default: `completed`) |

**Returns:**
- Final session summary

---

### kit_run_workflow

Execute a predefined workflow.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `workflow` | string | Yes | Workflow name (see below) |
| `task` | string | Yes | Task description |

**Available Workflows:**

| Name | Description |
|------|-------------|
| `cook` | Full cycle: Plan → Scout → Code → Test → Review |
| `quickfix` | Bug fix: Debug → Code → Test |
| `feature` | New feature: Design → Plan → Code → Test → Docs |
| `refactor` | Refactoring: Scout → Plan → Code → Test → Review |
| `review` | Code review: Scout → Review → Security |
| `tdd` | Test-driven: Plan → Test (fail) → Code → Test (pass) |
| `docs` | Documentation: Scout → Analyze → Write → Review |

---

### kit_smart_route

Analyze task and auto-select the best workflow.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `task` | string | Yes | Task description to analyze |

**Returns:**
- Recommended workflow
- Confidence score
- Reasoning
- Alternative workflows

---

### kit_list_workflows

List all available workflows.

**Parameters:** None

**Returns:**
- Array of workflows with name and description

---

### kit_session_history

Get history of past team sessions.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `limit` | number | No | Max sessions (default: 10) |

**Returns:**
- Array of past sessions with goal, status, and timing

---

## Hooks Reference

### session-start
Triggered when a new session begins. Initializes gemini-kit state.

### before-agent
Injects relevant learnings and project context before each agent response.

### before-tool
Security validation:
- Secret detection (API keys, tokens, passwords)
- Path traversal prevention
- Dangerous command blocking

### after-tool
Auto-runs tests after file changes to catch regressions early.

### session-end
Cleanup and saves session logs.

---

## Error Codes

| Code | Description |
|------|-------------|
| 0 | Success |
| 1 | General error |
| 2 | Security block (secret/dangerous command detected) |

---

## Configuration

Create `.gemini/settings.json` in your project to customize:

```json
{
  "fileExtensions": [".ts", ".js", ".tsx", ".jsx", ".py"],
  "excludeDirs": ["node_modules", "dist", ".git"]
}
```
