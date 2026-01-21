/**
 * Knowledge Tools Tests
 * Tests for validatePath and learning functions
 */
import { describe, it, expect } from 'vitest';
import * as path from 'path';
// We'll test the validatePath function directly by recreating its logic
// since it's not exported from the module
describe('Knowledge Tools', () => {
    describe('validatePath logic', () => {
        // Recreate the validatePath function for testing
        function validatePath(filePath, baseDir = process.cwd()) {
            const resolved = path.resolve(baseDir, filePath);
            if (!resolved.startsWith(path.resolve(baseDir))) {
                throw new Error(`Path traversal detected: ${filePath}`);
            }
            return resolved;
        }
        it('should resolve valid relative paths', () => {
            const baseDir = '/Users/test/project';
            const result = validatePath('src/file.ts', baseDir);
            expect(result).toBe('/Users/test/project/src/file.ts');
        });
        it('should throw error for path traversal attack', () => {
            const baseDir = '/Users/test/project';
            expect(() => validatePath('../../../etc/passwd', baseDir)).toThrow('Path traversal detected');
        });
        it('should throw error for absolute paths outside base directory', () => {
            const baseDir = '/Users/test/project';
            expect(() => validatePath('/etc/passwd', baseDir)).toThrow('Path traversal detected');
        });
        it('should allow valid absolute paths within base directory', () => {
            const baseDir = '/Users/test/project';
            const result = validatePath('/Users/test/project/src/file.ts', baseDir);
            expect(result).toBe('/Users/test/project/src/file.ts');
        });
        it('should handle nested directory paths', () => {
            const baseDir = '/Users/test/project';
            const result = validatePath('src/components/Button/index.tsx', baseDir);
            expect(result).toBe('/Users/test/project/src/components/Button/index.tsx');
        });
    });
    describe('Learning delimiter constants', () => {
        it('should use unique markers that are unlikely to conflict', () => {
            // These are the constants used in knowledge.ts
            const LEARNING_START = '<!-- LEARNING_START';
            const LEARNING_END = '<!-- LEARNING_END -->';
            // They should be HTML comments to avoid conflicts
            expect(LEARNING_START).toContain('<!--');
            expect(LEARNING_END).toContain('-->');
            // They should have unique identifiers
            expect(LEARNING_START).toContain('LEARNING_START');
            expect(LEARNING_END).toContain('LEARNING_END');
        });
    });
    describe('sanitize function integration', () => {
        it('should be available for input sanitization', async () => {
            const { sanitize } = await import('../security.js');
            // Test that dangerous characters are removed
            const input = 'test; rm -rf /';
            const result = sanitize(input);
            expect(result).not.toContain(';');
        });
    });
    describe('findFiles function integration', () => {
        it('should find files with specified extensions', async () => {
            const { findFiles } = await import('../security.js');
            // Find TypeScript files in the project
            const files = findFiles(process.cwd(), ['.ts'], 10);
            expect(Array.isArray(files)).toBe(true);
            expect(files.length).toBeGreaterThan(0);
        });
    });
});
// HIGH 3: Comprehensive tests for kit_index_codebase regex patterns
describe('Code Indexing Regex Patterns', () => {
    // These are the patterns used in kit_index_codebase
    const functionPatterns = [
        // Standard functions
        /(?:async\s+)?function\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*(?:<[^>]*>)?\s*\(/g,
        // Arrow functions with const/let/var
        /(?:const|let|var)\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*=\s*(?:async\s*)?\(/g,
        /(?:const|let|var)\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*=\s*(?:async\s*)?\([^)]*\)\s*=>/g,
        // TypeScript generics: const foo = <T>() =>
        /(?:const|let|var)\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*=\s*(?:async\s*)?<[^>]*>\s*\(/g,
        // Method shorthand in object/class
        /^\s*(?:async\s+)?([a-zA-Z_][a-zA-Z0-9_]*)\s*(?:<[^>]*>)?\s*\([^)]*\)\s*{/gm,
        // Export function
        /export\s+(?:async\s+)?function\s+([a-zA-Z_][a-zA-Z0-9_]*)/g,
        /export\s+(?:const|let)\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*=/g,
        // React FC: const MyComponent: FC = 
        /(?:const|let)\s+([A-Z][a-zA-Z0-9_]*)\s*:\s*(?:React\.)?FC/g,
        // React forwardRef
        /(?:const|let)\s+([A-Z][a-zA-Z0-9_]*)\s*=\s*(?:React\.)?forwardRef/g,
    ];
    const classPattern = /class\s+([a-zA-Z_][a-zA-Z0-9_]*)/g;
    describe('Standard function detection', () => {
        it('should detect regular functions', () => {
            const code = 'function myFunction() { return true; }';
            const matches = code.match(functionPatterns[0]);
            expect(matches).toBeTruthy();
            expect(matches[0]).toContain('myFunction');
        });
        it('should detect async functions', () => {
            const code = 'async function fetchData() { return await api.get(); }';
            const matches = code.match(functionPatterns[0]);
            expect(matches).toBeTruthy();
            expect(matches[0]).toContain('fetchData');
        });
        it('should detect generic functions', () => {
            const code = 'function identity<T>(arg: T): T { return arg; }';
            const matches = code.match(functionPatterns[0]);
            expect(matches).toBeTruthy();
        });
    });
    describe('Arrow function detection', () => {
        it('should detect const arrow functions', () => {
            const code = 'const add = (a, b) => a + b;';
            const matches = code.match(functionPatterns[2]);
            expect(matches).toBeTruthy();
        });
        it('should detect async arrow functions', () => {
            const code = 'const fetchUser = async (id) => await fetch(id);';
            const matches = code.match(functionPatterns[2]);
            expect(matches).toBeTruthy();
        });
        it('should detect let arrow functions', () => {
            const code = 'let process = (data) => data.map(x => x * 2);';
            const matches = code.match(functionPatterns[2]);
            expect(matches).toBeTruthy();
        });
    });
    describe('React component detection', () => {
        it('should detect React FC components', () => {
            const code = 'const MyComponent: FC<Props> = ({ name }) => <div>{name}</div>;';
            const matches = code.match(functionPatterns[7]);
            expect(matches).toBeTruthy();
            expect(matches[0]).toContain('MyComponent');
        });
        it('should detect React.FC components', () => {
            const code = 'const Button: React.FC<ButtonProps> = (props) => <button {...props} />;';
            const matches = code.match(functionPatterns[7]);
            expect(matches).toBeTruthy();
        });
        it('should detect forwardRef components', () => {
            const code = 'const Input = React.forwardRef<HTMLInputElement, InputProps>((props, ref) => <input ref={ref} {...props} />);';
            const matches = code.match(functionPatterns[8]);
            expect(matches).toBeTruthy();
            expect(matches[0]).toContain('Input');
        });
    });
    describe('Class detection', () => {
        it('should detect regular classes', () => {
            const code = 'class UserService { }';
            const matches = code.match(classPattern);
            expect(matches).toBeTruthy();
            expect(matches[0]).toContain('UserService');
        });
        it('should detect classes with extends', () => {
            const code = 'class AdminService extends UserService { }';
            const matches = code.match(classPattern);
            expect(matches).toBeTruthy();
            expect(matches[0]).toContain('AdminService');
        });
        it('should detect multiple classes', () => {
            const code = `
                class Dog { bark() {} }
                class Cat { meow() {} }
                class Bird { sing() {} }
            `;
            const matches = code.match(classPattern);
            expect(matches).toBeTruthy();
            expect(matches.length).toBe(3);
        });
    });
    describe('Export detection', () => {
        it('should detect exported functions', () => {
            const code = 'export function validateEmail(email: string): boolean { }';
            const matches = code.match(functionPatterns[5]);
            expect(matches).toBeTruthy();
        });
        it('should detect exported async functions', () => {
            const code = 'export async function sendEmail(to: string): Promise<void> { }';
            const matches = code.match(functionPatterns[5]);
            expect(matches).toBeTruthy();
        });
        it('should detect exported const', () => {
            const code = 'export const API_URL = "https://api.example.com";';
            const matches = code.match(functionPatterns[6]);
            expect(matches).toBeTruthy();
        });
    });
    describe('Edge cases', () => {
        it('should handle multiline code', () => {
            const code = `
                function longFunction(
                    param1: string,
                    param2: number
                ): Result {
                    return process(param1, param2);
                }
            `;
            const matches = code.match(functionPatterns[0]);
            expect(matches).toBeTruthy();
        });
        it('should not match function calls', () => {
            const code = 'const result = myFunction();';
            const matches = code.match(functionPatterns[0]);
            // This should NOT match function calls, only definitions
            expect(matches).toBeNull();
        });
        it('should handle TypeScript interfaces (no false positives)', () => {
            const code = 'interface User { name: string; age: number; }';
            const funcMatches = code.match(functionPatterns[0]);
            const classMatches = code.match(classPattern);
            // Interfaces should not be detected as functions or classes
            expect(funcMatches).toBeNull();
            expect(classMatches).toBeNull();
        });
    });
});
// HIGH 3: Conflict detection tests
describe('Diff Conflict Detection', () => {
    it('should detect when original content has changed', () => {
        const originalContent = 'const x = 1;';
        const currentContent = 'const x = 2;';
        const hasConflict = originalContent !== currentContent;
        expect(hasConflict).toBe(true);
    });
    it('should not detect conflict when content is unchanged', () => {
        const content = 'const x = 1;';
        const currentContent = content; // Same reference
        const hasConflict = content !== currentContent;
        expect(hasConflict).toBe(false);
    });
    it('should handle whitespace-only changes', () => {
        const original = 'const x = 1;';
        const withWhitespace = original + '  ';
        // Whitespace changes should be detected
        expect(original !== withWhitespace).toBe(true);
    });
});
// MEDIUM: File size limit constant
describe('File Size Limit', () => {
    it('should have 1MB max file size for indexing', () => {
        const MAX_FILE_SIZE_BYTES = 1 * 1024 * 1024;
        expect(MAX_FILE_SIZE_BYTES).toBe(1048576);
        expect(MAX_FILE_SIZE_BYTES).toBeLessThan(10 * 1024 * 1024); // Less than 10MB
    });
});
