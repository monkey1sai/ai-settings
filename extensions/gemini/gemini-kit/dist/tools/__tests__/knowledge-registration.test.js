/**
 * Knowledge Registration Tests - Test registerKnowledgeTools with mocked MCP server
 */
import { describe, it, expect, beforeEach, vi } from 'vitest';
// Mock all dependencies BEFORE importing
vi.mock('fs', () => ({
    existsSync: vi.fn(),
    mkdirSync: vi.fn(),
    writeFileSync: vi.fn(),
    readFileSync: vi.fn(),
    appendFileSync: vi.fn(),
    readdirSync: vi.fn(),
    statSync: vi.fn(),
}));
vi.mock('path', async () => {
    const actual = await vi.importActual('path');
    return { ...actual };
});
vi.mock('diff', () => ({
    createPatch: vi.fn(),
    applyPatch: vi.fn(),
}));
vi.mock('../security.js', () => ({
    sanitize: vi.fn((x) => x),
    homeDir: '/tmp/test-home',
    findFiles: vi.fn().mockReturnValue([]),
}));
import * as fs from 'fs';
describe('registerKnowledgeTools - Full Coverage', () => {
    let mockServer;
    let registeredTools;
    beforeEach(() => {
        vi.clearAllMocks();
        registeredTools = new Map();
        mockServer = {
            tool: vi.fn((name, description, schema, handler) => {
                registeredTools.set(name, { description, schema, handler });
            }),
        };
    });
    it('should register all knowledge tools', async () => {
        const { registerKnowledgeTools } = await import('../knowledge.js');
        registerKnowledgeTools(mockServer);
        expect(registeredTools.has('kit_save_learning')).toBe(true);
        expect(registeredTools.has('kit_get_learnings')).toBe(true);
        expect(registeredTools.has('kit_store_diff')).toBe(true);
        expect(registeredTools.has('kit_apply_stored_diff')).toBe(true);
        expect(registeredTools.has('kit_index_codebase')).toBe(true);
        expect(registeredTools.has('kit_keyword_search')).toBe(true);
    });
    describe('kit_save_learning', () => {
        it('should save learning successfully', async () => {
            vi.mocked(fs.existsSync).mockReturnValue(true);
            vi.mocked(fs.appendFileSync).mockReturnValue(undefined);
            const { registerKnowledgeTools } = await import('../knowledge.js');
            registerKnowledgeTools(mockServer);
            const tool = registeredTools.get('kit_save_learning');
            const result = await tool.handler({
                category: 'code_style',
                lesson: 'Use arrow functions',
                context: 'User preference'
            });
            expect(result.content[0].text).toContain('Learning saved');
        });
        it('should create learnings file if not exists', async () => {
            vi.mocked(fs.existsSync).mockReturnValue(false);
            vi.mocked(fs.writeFileSync).mockReturnValue(undefined);
            vi.mocked(fs.appendFileSync).mockReturnValue(undefined);
            const { registerKnowledgeTools } = await import('../knowledge.js');
            registerKnowledgeTools(mockServer);
            const tool = registeredTools.get('kit_save_learning');
            await tool.handler({ category: 'bug', lesson: 'Check null' });
            expect(fs.writeFileSync).toHaveBeenCalled();
        });
        it('should handle errors', async () => {
            vi.mocked(fs.existsSync).mockImplementation(() => {
                throw new Error('Permission denied');
            });
            const { registerKnowledgeTools } = await import('../knowledge.js');
            registerKnowledgeTools(mockServer);
            const tool = registeredTools.get('kit_save_learning');
            const result = await tool.handler({ category: 'other', lesson: 'test' });
            expect(result.content[0].text).toContain('Error');
        });
    });
    describe('kit_get_learnings', () => {
        it('should get all learnings', async () => {
            vi.mocked(fs.existsSync).mockReturnValue(true);
            vi.mocked(fs.readFileSync).mockReturnValue(`
<!-- LEARNING_START:code_style:123 -->
**Lesson:** Use arrow functions
<!-- LEARNING_END -->
`);
            const { registerKnowledgeTools } = await import('../knowledge.js');
            registerKnowledgeTools(mockServer);
            const tool = registeredTools.get('kit_get_learnings');
            const result = await tool.handler({});
            expect(result.content[0].text).toBeDefined();
        });
        it('should return message for no learnings', async () => {
            vi.mocked(fs.existsSync).mockReturnValue(false);
            const { registerKnowledgeTools } = await import('../knowledge.js');
            registerKnowledgeTools(mockServer);
            const tool = registeredTools.get('kit_get_learnings');
            const result = await tool.handler({});
            expect(result.content[0].text).toContain('No learnings');
        });
        it('should handle read errors', async () => {
            vi.mocked(fs.existsSync).mockReturnValue(true);
            vi.mocked(fs.readFileSync).mockImplementation(() => {
                throw new Error('Read error');
            });
            const { registerKnowledgeTools } = await import('../knowledge.js');
            registerKnowledgeTools(mockServer);
            const tool = registeredTools.get('kit_get_learnings');
            const result = await tool.handler({});
            expect(result.content[0].text).toContain('Error');
        });
    });
    describe('kit_store_diff', () => {
        it('should store diff successfully', async () => {
            vi.mocked(fs.existsSync).mockReturnValue(true);
            const Diff = await import('diff');
            vi.mocked(Diff.createPatch).mockReturnValue('--- a\n+++ b\n');
            const { registerKnowledgeTools } = await import('../knowledge.js');
            registerKnowledgeTools(mockServer);
            const tool = registeredTools.get('kit_store_diff');
            const result = await tool.handler({
                file: 'test.ts',
                originalContent: 'old content',
                newContent: 'new content',
                description: 'Test change'
            });
            expect(result.content[0].text).toBeDefined();
        });
    });
    describe('kit_apply_stored_diff', () => {
        it('should handle diff not found', async () => {
            vi.mocked(fs.existsSync).mockReturnValue(false);
            const { registerKnowledgeTools } = await import('../knowledge.js');
            registerKnowledgeTools(mockServer);
            const tool = registeredTools.get('kit_apply_stored_diff');
            const result = await tool.handler({ diffId: 'nonexistent' });
            expect(result.content[0].text).toContain('not found');
        });
    });
    describe('kit_keyword_search', () => {
        it('should search codebase', async () => {
            const security = await import('../security.js');
            vi.mocked(security.findFiles).mockReturnValue(['src/file.ts']);
            vi.mocked(fs.readFileSync).mockReturnValue('function test() {}');
            const { registerKnowledgeTools } = await import('../knowledge.js');
            registerKnowledgeTools(mockServer);
            const tool = registeredTools.get('kit_keyword_search');
            const result = await tool.handler({
                query: 'function',
                directory: '/project'
            });
            expect(result.content[0].text).toBeDefined();
        });
        it('should handle no matches', async () => {
            const security = await import('../security.js');
            vi.mocked(security.findFiles).mockReturnValue([]);
            const { registerKnowledgeTools } = await import('../knowledge.js');
            registerKnowledgeTools(mockServer);
            const tool = registeredTools.get('kit_keyword_search');
            const result = await tool.handler({
                query: 'nonexistent',
                directory: '/project'
            });
            expect(result.content[0].text).toBeDefined();
        });
    });
});
