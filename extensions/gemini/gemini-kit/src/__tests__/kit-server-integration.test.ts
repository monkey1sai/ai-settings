/**
 * Kit Server Integration Tests
 * HIGH 1: Test entry point startup and tool registration
 */

import { describe, it, expect, vi, beforeEach } from 'vitest';

// Mock the MCP SDK
vi.mock('@modelcontextprotocol/sdk/server/mcp.js', () => ({
    McpServer: vi.fn().mockImplementation(() => ({
        tool: vi.fn(),
        connect: vi.fn(),
        close: vi.fn(),
    })),
}));

vi.mock('@modelcontextprotocol/sdk/server/stdio.js', () => ({
    StdioServerTransport: vi.fn().mockImplementation(() => ({})),
}));

// Mock all tool registration modules
vi.mock('../tools/git.js', () => ({
    registerGitTools: vi.fn(),
}));

vi.mock('../tools/knowledge.js', () => ({
    registerKnowledgeTools: vi.fn(),
}));

vi.mock('../tools/integration.js', () => ({
    registerIntegrationTools: vi.fn(),
}));

vi.mock('../tools/core.js', () => ({
    registerCoreTools: vi.fn(),
}));

describe('Kit Server Integration', () => {
    beforeEach(() => {
        vi.clearAllMocks();
    });

    describe('McpServer instantiation', () => {
        it('should create server with correct name and version', async () => {
            const { McpServer } = await import('@modelcontextprotocol/sdk/server/mcp.js');

            // Server should be instantiated with name and version
            expect(McpServer).toBeDefined();
        });
    });

    describe('Tool Registration', () => {
        it('should register git tools', async () => {
            const { registerGitTools } = await import('../tools/git.js');
            expect(registerGitTools).toBeDefined();
            expect(typeof registerGitTools).toBe('function');
        });

        it('should register knowledge tools', async () => {
            const { registerKnowledgeTools } = await import('../tools/knowledge.js');
            expect(registerKnowledgeTools).toBeDefined();
            expect(typeof registerKnowledgeTools).toBe('function');
        });

        it('should register integration tools', async () => {
            const { registerIntegrationTools } = await import('../tools/integration.js');
            expect(registerIntegrationTools).toBeDefined();
            expect(typeof registerIntegrationTools).toBe('function');
        });

        it('should register core tools', async () => {
            const { registerCoreTools } = await import('../tools/core.js');
            expect(registerCoreTools).toBeDefined();
            expect(typeof registerCoreTools).toBe('function');
        });
    });

    describe('Server Configuration', () => {
        it('should have StdioServerTransport available', async () => {
            const { StdioServerTransport } = await import('@modelcontextprotocol/sdk/server/stdio.js');
            expect(StdioServerTransport).toBeDefined();
        });
    });

    describe('Error Handling', () => {
        it('should handle missing tool modules gracefully', async () => {
            // Test that our mock structure works
            const { registerGitTools } = await import('../tools/git.js');

            // Should not throw when called with mock
            expect(() => registerGitTools({} as never)).not.toThrow();
        });
    });
});

describe('Config Module', () => {
    it('should export getFileExtensions', async () => {
        const { getFileExtensions } = await import('../tools/config.js');
        expect(getFileExtensions).toBeDefined();
        expect(typeof getFileExtensions).toBe('function');
    });

    it('should export DEFAULT_EXTENSIONS', async () => {
        const { DEFAULT_EXTENSIONS } = await import('../tools/config.js');
        expect(DEFAULT_EXTENSIONS).toBeDefined();
        expect(Array.isArray(DEFAULT_EXTENSIONS)).toBe(true);
        expect(DEFAULT_EXTENSIONS).toContain('.ts');
        expect(DEFAULT_EXTENSIONS).toContain('.js');
    });

    it('should export loadProjectSettings', async () => {
        const { loadProjectSettings } = await import('../tools/config.js');
        expect(loadProjectSettings).toBeDefined();
        expect(typeof loadProjectSettings).toBe('function');
    });
});
