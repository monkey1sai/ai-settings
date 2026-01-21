/**
 * Test Mock Types - Shared types for all tests
 * Properly typed mock objects instead of using 'any'
 */
/**
 * Create a mock MCP server for testing
 */
export function createMockServer() {
    return {
        tool: vi.fn(),
    };
}
/**
 * Create a tools registry map
 */
export function createToolsRegistry() {
    return new Map();
}
// Export vi for convenience (tests import from vitest anyway)
import { vi } from 'vitest';
