#!/usr/bin/env node
/**
 * BeforeTool Hook
 * Security validation - block secrets and dangerous commands
 * 
 * Enhanced with:
 * - More secret patterns (Bearer, private keys, npm, pypi, Anthropic)
 * - Path traversal prevention
 * - Sensitive file blocking
 */

// Secret patterns to detect
const SECRET_PATTERNS = [
    // Generic patterns
    /api[_-]?key\s*[:=]\s*['"]?[a-zA-Z0-9_-]{20,}['"]?/i,
    /password\s*[:=]\s*['"]?[^\s'"]{8,}['"]?/i,
    /secret\s*[:=]\s*['"]?[a-zA-Z0-9_-]{20,}['"]?/i,
    /token\s*[:=]\s*['"]?[a-zA-Z0-9_-]{20,}['"]?/i,

    // Cloud providers
    /AKIA[0-9A-Z]{16}/,                           // AWS Access Key
    /(?:aws)?[_-]?secret[_-]?access[_-]?key/i,    // AWS Secret Key label

    // Code hosting & CI
    /ghp_[a-zA-Z0-9]{36}/,                        // GitHub Personal Token
    /gho_[a-zA-Z0-9]{36}/,                        // GitHub OAuth Token
    /ghu_[a-zA-Z0-9]{36}/,                        // GitHub User Token
    /ghr_[a-zA-Z0-9]{36}/,                        // GitHub Refresh Token
    /github_pat_[a-zA-Z0-9]{22}_[a-zA-Z0-9]{59}/, // GitHub Fine-grained PAT
    /glpat-[a-zA-Z0-9\-_]{20,}/,                  // GitLab Personal Token

    // AI providers
    /sk-[a-zA-Z0-9]{48}/,                         // OpenAI API Key
    /sk-proj-[a-zA-Z0-9]{48}/,                    // OpenAI Project Key
    /sk-ant-[a-zA-Z0-9\-_]{95}/,                  // Anthropic API Key
    /AIza[a-zA-Z0-9_-]{35}/,                      // Google API Key

    // Communication
    /xox[baprs]-[a-zA-Z0-9-]{10,}/,               // Slack Token
    /https:\/\/hooks\.slack\.com\/services\//,    // Slack Webhook

    // Package managers
    /npm_[a-zA-Z0-9]{36}/,                        // NPM Token
    /pypi-[a-zA-Z0-9]{50,}/,                      // PyPI Token

    // Auth tokens
    /Bearer\s+[a-zA-Z0-9_-]{20,}/i,               // Bearer tokens
    /Authorization:\s*Bearer/i,                   // Auth header

    // Private keys
    /-----BEGIN\s+(?:RSA\s+)?PRIVATE\s+KEY-----/, // Private keys
    /-----BEGIN\s+OPENSSH\s+PRIVATE\s+KEY-----/,  // OpenSSH keys
    /-----BEGIN\s+EC\s+PRIVATE\s+KEY-----/,       // EC keys

    // Database
    /mongodb\+srv:\/\/[^:]+:[^@]+@/,              // MongoDB connection string
    /postgres:\/\/[^:]+:[^@]+@/,                  // PostgreSQL connection string
    /mysql:\/\/[^:]+:[^@]+@/,                     // MySQL connection string
];

// Dangerous shell commands
const DANGEROUS_COMMANDS = [
    'rm -rf /',
    'rm -rf ~',
    'rm -rf *',
    'dd if=',
    ':(){:|:&};:',
    'mkfs.',
    'sudo rm',
    '> /dev/sda',
    'chmod 777 /',
    'wget | sh',
    'curl | sh',
    'curl | bash',
];

// Dangerous file paths
const DANGEROUS_PATHS = [
    /\.\.\//,                           // Path traversal
    /\/etc\/passwd/,
    /\/etc\/shadow/,
    /\/etc\/hosts/,
    /~\/\.ssh/,
    /\.ssh\/id_/,
    /\.env$/,
    /\.env\.local$/,
    /\.env\.production$/,
    /credentials/i,
    /\.pem$/,
    /\.key$/,
];

// Helper to deny with message
function deny(reason, systemMessage) {
    console.log(JSON.stringify({
        decision: 'deny',
        reason,
        systemMessage: systemMessage || '⛔ Security check failed',
    }));
    process.exit(2);
}

async function main(input) {
    // Parse input safely
    let data;
    try {
        data = JSON.parse(input);
    } catch (error) {
        // If parse fails, deny (fail-closed for security)
        deny(
            `Invalid input format: ${error.message}`,
            '⛔ Security: Malformed input blocked'
        );
        return;
    }

    const { tool_name, tool_input } = data;

    // Check for secrets in file content
    const content = tool_input?.content || tool_input?.new_string || '';

    for (const pattern of SECRET_PATTERNS) {
        if (pattern.test(content)) {
            deny(
                '🚨 Potential secret/API key detected. Remove sensitive data before proceeding.',
                '🔐 Secret scanner blocked operation'
            );
        }
    }

    // Check file path for WriteFile operations
    if (['WriteFile', 'Edit', 'write_file', 'edit'].includes(tool_name)) {
        const filePath = tool_input?.file_path || tool_input?.path || '';

        for (const pattern of DANGEROUS_PATHS) {
            if (pattern.test(filePath)) {
                deny(
                    `🚫 Dangerous file path detected: ${filePath}`,
                    '⛔ Path security check failed'
                );
            }
        }
    }

    // Check for dangerous shell commands
    if (tool_name === 'RunShellCommand' || tool_name === 'run_shell_command') {
        const cmd = tool_input?.command || '';

        for (const dangerous of DANGEROUS_COMMANDS) {
            if (cmd.includes(dangerous)) {
                deny(
                    `🚫 Dangerous command blocked: ${dangerous}`,
                    '⛔ Dangerous command blocked'
                );
            }
        }
    }

    // All checks passed
    console.log(JSON.stringify({ decision: 'allow' }));
}

// Read stdin
const input = await new Promise(resolve => {
    let data = '';
    process.stdin.on('data', chunk => data += chunk);
    process.stdin.on('end', () => resolve(data));
});

main(input).catch((error) => {
    // Fail-closed: deny on any error for security
    console.log(JSON.stringify({
        decision: 'deny',
        reason: `Security check error: ${error.message}`,
        systemMessage: '⛔ Security: Error during validation'
    }));
    process.exit(2);
});

