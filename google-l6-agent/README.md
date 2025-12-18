# Google L6 Agent

A VS Code Chat Participant that acts as a Google L6 Senior Engineer.

## Features

- **@google工程師**: Chat with a Google L6 Senior Engineer persona.
- **review**: Review code with Google engineering standards.
- **arch**: Design system architecture.

## Usage

1. Open GitHub Copilot Chat.
2. Type `@google工程師` to start chatting.

## Install

### Install from VSIX (CLI)

```bash
code --install-extension C:\.vscode\agent-prompts\google-l6-agent\vscode-agents-0.0.1.vsix
```

## Prompt Overrides

If you would like to tweak a persona without rebuilding the extension, set the `vscodeAgents.promptOverrideFolder` configuration in your workspace settings. Point it to a folder (relative or absolute) containing files such as `ai_agent.prompt.md`, `ai_data.prompt.md`, etc. Whenever the extension finds a matching file, it will use that text instead of the built-in prompt while leaving the existing personas intact.

### Example

1. Create a folder in your project root: `prompts_override/`
2. Add a file like `prompts_override/ai_agent.prompt.md`
3. Set workspace setting:

```json
{
	"vscodeAgents.promptOverrideFolder": "prompts_override"
}
```

### Debug Prompt Source (Optional)

Enable `vscodeAgents.debugPromptSource` to print a short debug line in each response indicating whether the built-in prompt or an override file was used.
