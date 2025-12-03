// サンプルテストファイル

describe('Example Test', () => {
  it('1 + 1 は 2 である', () => {
    expect(1 + 1).toBe(2);
  });

  it('配列に要素が含まれる', () => {
    const arr = ['a', 'b', 'c'];
    expect(arr).toContain('b');
  });
});
