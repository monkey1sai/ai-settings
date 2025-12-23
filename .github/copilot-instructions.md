# Copilot instructions (vscode-agents)

## Repo layout (important)
- Extension project lives in `repo/` (build/test/debug from there). The workspace root is a wrapper repo.
- Personas (prompts) source of truth: `repo/.vscode_prompt/`.
- Generated artifacts (do not hand-edit): `repo/src/prompts.ts` and `repo/package.json` → `contributes.chatParticipants`.

## Big picture
- VS Code extension registers multiple Copilot Chat participants (personas) at activation.
- Entry: `repo/src/extension.ts` creates one participant per `PROMPTS` entry (`repo/src/prompts.ts`).
- Prompt override flow:
  - Setting `vscodeAgents.promptOverrideFolder` points to a folder containing `ai_agent.prompt.md` etc.
  - Runtime loads overrides without restarting Extension Host; `vscodeAgents.debugPromptSource` prints the source line.

## Prompt generation workflow (when adding/updating personas)
- Add/update a `*.prompt.md` file in `repo/.vscode_prompt/`.
- Run (from `repo/`):
  - `node generate_prompts.js`
- Notes:
  - `generate_prompts.js` enforces VS Code chat command names to match `/^[\w-]+$/`.
  - Chinese filenames are mapped via `nameMapping` in `generate_prompts.js` (update mapping when adding a new Chinese-named persona).

## Dev commands (run in `repo/`)
- Install: `npm ci`
- Build: `npm run compile`
- Watch: `npm run watch` (wired to `.vscode/tasks.json` as the default build task)
- Lint: `npm run lint`

## Debugging
- Use `.vscode/launch.json` → “Run Extension” to launch an Extension Host.
- Chat participants are declared in `repo/package.json` (`contributes.chatParticipants`) and activated via `onChatParticipant:...` events.

## Release/publish
- GitHub Actions publishes on tag `v*`: `.github/workflows/publish.yml` (working-directory is `repo`).
- Requires `VSCE_PAT` secret; local publish uses `npx --yes @vscode/vsce publish -p <VSCE_PAT>`.

## Codebase conventions
- Overrides may include fenced code blocks; loader strips outer ``` fences (`readPromptFile` in `repo/src/extension.ts`).
- The extension sends the persona prompt + user prompt as chat messages to the selected model (do not hardcode model IDs).
