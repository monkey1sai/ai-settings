import * as fs from 'fs';
import * as path from 'path';
import * as vscode from 'vscode';
import { PROMPTS } from './prompts';

interface IChatResult extends vscode.ChatResult {
    metadata: {
        command: string;
    }
}

export function activate(context: vscode.ExtensionContext) {
    const loggedOverrides = new Set<string>();

    const createHandler = (participantId: string, defaultPrompt: string) => {
        return async (request: vscode.ChatRequest, context: vscode.ChatContext, stream: vscode.ChatResponseStream, token: vscode.CancellationToken): Promise<IChatResult> => {
            const overrideFolder = resolveOverrideFolder('promptOverrideFolder');
            const debugEnabled = vscode.workspace.getConfiguration('vscodeAgents').get<boolean>('debugPromptSource', false);

            const overrideInfo = loadOverridePromptInfo(participantId, overrideFolder);
            const systemPrompt = overrideInfo?.prompt ?? defaultPrompt;

            if (debugEnabled) {
                const source = overrideInfo ? 'override' : 'built-in';
                const from = overrideInfo?.filePath ? ` (${overrideInfo.filePath})` : '';
                stream.markdown(`\n\n[debug] prompt source: ${source}${from}\n\n`);
            }

            if (overrideInfo && !loggedOverrides.has(participantId)) {
                loggedOverrides.add(participantId);
                console.log(`[vscode-agents] Using override prompt for ${participantId} from ${overrideInfo.filePath}`);
            }

            const model = request.model;
            const messages = [
                vscode.LanguageModelChatMessage.User(systemPrompt),
                vscode.LanguageModelChatMessage.User(request.prompt)
            ];

            try {
                const chatResponse = await model.sendRequest(messages, {}, token);
                for await (const fragment of chatResponse.text) {
                    stream.markdown(fragment);
                }
            } catch (err) {
                if (err instanceof Error) {
                    stream.markdown(`Error: ${err.message}`);
                }
            }

            return { metadata: { command: '' } };
        };
    };

    for (const [id, prompt] of Object.entries(PROMPTS)) {
        if (!prompt) {
            continue;
        }

        const participant = vscode.chat.createChatParticipant(id, createHandler(id, prompt));
        participant.iconPath = new vscode.ThemeIcon('sparkle');
        context.subscriptions.push(participant);
    }
}

export function deactivate() {}

function resolveOverrideFolder(configKey: string): string | undefined {
    const config = vscode.workspace.getConfiguration('vscodeAgents');
    const rawValue = config.get<string>(configKey, '')?.trim();
    if (!rawValue) {
        return undefined;
    }

    const candidates: string[] = [];
    if (path.isAbsolute(rawValue)) {
        candidates.push(rawValue);
    }

    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    if (workspaceFolder) {
        candidates.push(path.join(workspaceFolder.uri.fsPath, rawValue));
    }

    for (const candidate of candidates) {
        try {
            if (fs.existsSync(candidate) && fs.statSync(candidate).isDirectory()) {
                return candidate;
            }
        } catch {
            // ignore invalid candidates
        }
    }

    return undefined;
}

function loadOverridePrompt(id: string, folder?: string): string | undefined {
    return loadOverridePromptInfo(id, folder)?.prompt;
}

function loadOverridePromptInfo(id: string, folder?: string): { prompt: string; filePath: string } | undefined {
    if (!folder) {
        return undefined;
    }

    const baseName = id.startsWith('agent.') ? id.substring('agent.'.length) : id;
    const candidates = [
        `${baseName}.prompt.md`,
        `${baseName}.md`,
        `${id}.prompt.md`,
        `${id}.md`
    ];

    for (const candidate of candidates) {
        const filePath = path.join(folder, candidate);
        try {
            if (fs.existsSync(filePath) && fs.statSync(filePath).isFile()) {
                return { prompt: readPromptFile(filePath), filePath };
            }
        } catch {
            continue;
        }
    }

    return undefined;
}

function readPromptFile(filePath: string): string {
    const content = fs.readFileSync(filePath, 'utf8');
    return stripCodeBlocks(content);
}

function stripCodeBlocks(content: string): string {
    const lines = content.split(/\r?\n/);
    if (lines.length > 0 && lines[0].trim().startsWith('```')) {
        lines.shift();
    }
    if (lines.length > 0 && lines[lines.length - 1].trim().startsWith('```')) {
        lines.pop();
    }
    return lines.join('\n');
}
