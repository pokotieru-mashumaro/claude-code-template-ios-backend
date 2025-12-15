// ============================================
// React Component テンプレート
// ファイル名: components/features/[feature]/FeatureName.tsx
// ============================================

'use client';

import { useState } from 'react';
import { Button } from '@/components/ui/button';

interface FeatureNameProps {
  // TODO: Props を定義
  title: string;
  onSubmit?: (data: unknown) => void;
}

export function FeatureName({ title, onSubmit }: FeatureNameProps) {
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async () => {
    setIsLoading(true);
    setError(null);

    try {
      // TODO: 処理を実装
      onSubmit?.({});
    } catch (err) {
      setError(err instanceof Error ? err.message : 'エラーが発生しました');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="p-4">
      <h2 className="text-xl font-bold mb-4">{title}</h2>

      {error && (
        <div className="bg-red-50 text-red-600 p-3 rounded mb-4">
          {error}
        </div>
      )}

      {/* TODO: コンテンツを実装 */}

      <Button onClick={handleSubmit} isLoading={isLoading}>
        送信
      </Button>
    </div>
  );
}
