# VS Code Agents

一組可在 GitHub Copilot Chat 中使用的多角色（persona）Agents，可用 `@` 指令快速切換。

## Features

- 多個可切換的 Chat Agents（例如：`@ai_agent`, `@ai_infra`, `@ai_test`, `@ai_data`, `@ai_product`, `@ddd_engineer`...）
- 依 Copilot Chat 當下選擇的模型回覆（不硬編碼模型）
- 支援外部提示詞覆寫（不需重啟 Extension Host）

## Usage

1. Open GitHub Copilot Chat.
2. Type `@ai_agent` (or other agent command) to start chatting.

## Install

### Install from VSIX (CLI)

```bash
code --install-extension C:\.vscode\agent-prompts\google-l6-agent\vscode-agents-0.0.3.vsix
```

## GitHub Sponsors

如果你覺得這個 extension 對你有幫助，歡迎透過 GitHub Sponsors 支持：

- https://github.com/sponsors/monkey1sai

## Publish (VS Code Marketplace)

你需要先在 VS Code Marketplace 建立 publisher `monkey1sai`，並取得可發布的 PAT（Personal Access Token）。

### 最短發布（本機）

1. 確保已編譯：

```bash
npm ci
npm run compile
```

2. 直接用 PAT 發布（不需要全域安裝 vsce）：

```bash
npx --yes @vscode/vsce publish -p <YOUR_VSCE_PAT>
```

### 用 GitHub Actions 自動發布（推薦）

1. 到 GitHub repo 的 Settings → Secrets and variables → Actions
2. 新增 secret：`VSCE_PAT`（值為你的 Marketplace 發布 PAT）
3. 推 tag（例如 `v0.0.2`）或手動觸發 workflow，即可自動發布：

```bash
git tag v0.0.3
git push --tags
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
