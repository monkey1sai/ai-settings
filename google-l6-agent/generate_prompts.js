const fs = require('fs');
const path = require('path');

const promptDir = '.vdcode_prompt';
const ignoredFiles = ['README.md', 'The Workflow Topology.md'];

// Mapping for Chinese filenames to valid command names (alphanumeric + - _)
// VS Code Chat Participant "name" (command) must match /^[\\w-]+$/
const nameMapping = {
    "AI Agent 工程師": "ai_agent",
    "AI 基礎設施": "ai_infra",
    "AI 測試工程師": "ai_test",
    "AI 資料工程師": "ai_data",
    "AI產品工程師": "ai_product",
    "領域驅動設計（DDD）工程師": "ddd_engineer",
    "架構滅絕師": "arch_destroyer",
    "超級codeing助理": "super_coding"
};

// Helper to clean filename
function cleanName(filename) {
    let name = filename.replace(/\.prompt\.md$/, '').replace(/\.md$/, '');
    name = name.replace(/\(\d+\)$/, '');
    return name.trim();
}

// Helper to generate valid ID
function getValidName(originalName) {
    if (nameMapping[originalName]) {
        return nameMapping[originalName];
    }
    // Fallback: replace invalid chars with _, remove duplicate _
    let valid = originalName.replace(/[^\w-]/g, '_').replace(/_+/g, '_');
    // If empty or still invalid (e.g. all Chinese), generate a random suffix
    if (!/^[\w-]+$/.test(valid) || valid === '_') {
        return 'agent_' + Math.random().toString(36).substring(7);
    }
    return valid.toLowerCase();
}

const files = fs.readdirSync(promptDir);
const prompts = {};
const participants = [];

files.forEach(file => {
    if (ignoredFiles.includes(file)) return;
    if (fs.statSync(path.join(promptDir, file)).isDirectory()) return;

    const originalName = cleanName(file);
    const validName = getValidName(originalName);
    const id = `agent.${validName}`;

    const content = fs.readFileSync(path.join(promptDir, file), 'utf8');
    
    // Clean content
    let cleanContent = content;
    const lines = cleanContent.split('\n');
    if (lines.length > 0 && lines[0].trim().startsWith('```')) lines.shift();
    if (lines.length > 0 && lines[lines.length - 1].trim().startsWith('```')) lines.pop();
    cleanContent = lines.join('\n');
    
    prompts[id] = cleanContent; // Use ID as key in prompts.ts

    participants.push({
        id: id,
        name: validName, // The command user types (e.g. @ai_agent)
        description: originalName, // Show Chinese name in UI description
        isSticky: true
    });
});

// Generate src/prompts.ts
let output = 'export const PROMPTS: { [key: string]: string } = {\n';
for (const [id, content] of Object.entries(prompts)) {
    const escaped = content.replace(/\\/g, '\\\\').replace(/`/g, '\\`').replace(/\${/g, '\\${');
    output += `    "${id}": \`\n${escaped}\n\`,\n`;
}
output += '};\n';
fs.writeFileSync('src/prompts.ts', output);
console.log('Generated src/prompts.ts');

// Update package.json
const packageJsonPath = 'package.json';
const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, 'utf8'));
packageJson.contributes.chatParticipants = participants;
fs.writeFileSync(packageJsonPath, JSON.stringify(packageJson, null, 2));
console.log('Updated package.json');
