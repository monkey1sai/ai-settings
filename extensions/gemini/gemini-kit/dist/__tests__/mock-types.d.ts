/**
 * Test Mock Types - Shared types for all tests
 * Properly typed mock objects instead of using 'any'
 */
import type { Mock } from 'vitest';
/**
 * Mock MCP Server interface for testing tool registration
 */
export interface MockMcpServer {
    tool: Mock<[name: string, description: string, schema: unknown, handler: ToolHandler]>;
    connect?: Mock;
}
/**
 * Tool handler function type
 */
export type ToolHandler = (args: Record<string, unknown>) => Promise<ToolResult>;
/**
 * Tool result type
 */
export interface ToolResult {
    content: Array<{
        type: 'text';
        text: string;
    }>;
}
/**
 * Registered tool info
 */
export interface RegisteredTool {
    description: string;
    schema: unknown;
    handler: ToolHandler;
}
/**
 * Create a mock MCP server for testing
 */
export declare function createMockServer(): MockMcpServer;
/**
 * Create a tools registry map
 */
export declare function createToolsRegistry(): Map<string, RegisteredTool>;
