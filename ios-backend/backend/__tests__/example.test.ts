// Jest Test Example
// このファイルはテストのサンプルです

import { describe, it, expect } from '@jest/globals';

describe('Example Test Suite', () => {
  it('should pass a simple test', () => {
    expect(1 + 1).toBe(2);
  });

  it('should handle async operations', async () => {
    const result = await Promise.resolve('success');
    expect(result).toBe('success');
  });

  describe('Array operations', () => {
    it('should contain an item', () => {
      const arr = [1, 2, 3];
      expect(arr).toContain(2);
    });

    it('should filter arrays', () => {
      const arr = [1, 2, 3, 4, 5];
      const filtered = arr.filter((n) => n > 2);
      expect(filtered).toEqual([3, 4, 5]);
    });
  });

  describe('Object operations', () => {
    it('should match object properties', () => {
      const obj = { name: 'Test', age: 30 };
      expect(obj).toMatchObject({ name: 'Test' });
    });
  });
});
