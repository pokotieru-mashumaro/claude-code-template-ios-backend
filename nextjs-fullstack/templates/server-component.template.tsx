// ============================================
// Server Component テンプレート
// ファイル名: app/(main)/[feature]/page.tsx
// ============================================

import { createClient } from '@/lib/supabase/server';
import { redirect } from 'next/navigation';

// メタデータ
export const metadata = {
  title: '[ページタイトル]',
  description: '[ページの説明]',
};

// データ取得関数
async function getData() {
  const supabase = await createClient();

  // 認証チェック
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) {
    redirect('/login');
  }

  // TODO: データ取得ロジック
  const { data, error } = await supabase
    .from('users')
    .select('*')
    .eq('id', user.id)
    .single();

  if (error) {
    throw new Error('データの取得に失敗しました');
  }

  return data;
}

// Page Component
export default async function FeaturePage() {
  const data = await getData();

  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-2xl font-bold mb-6">[ページタイトル]</h1>

      {/* TODO: コンテンツを実装 */}
      <pre>{JSON.stringify(data, null, 2)}</pre>
    </div>
  );
}
