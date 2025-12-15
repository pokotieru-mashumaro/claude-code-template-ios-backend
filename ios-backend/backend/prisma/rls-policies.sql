-- ===================================================================
-- Supabase Row Level Security (RLS) ポリシー設定
-- ===================================================================
-- このSQLファイルをSupabase SQL Editorで実行して、RLSを有効化してください。
--
-- 実行方法:
-- 1. Supabaseダッシュボードにログイン
-- 2. SQL Editor を開く
-- 3. このファイルの内容を貼り付けて実行
--
-- ===================================================================

-- ===================================================================
-- 1. RLSを有効化
-- ===================================================================

ALTER TABLE "User" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Post" ENABLE ROW LEVEL SECURITY;

-- ===================================================================
-- 2. User テーブルのポリシー
-- ===================================================================

-- 全ユーザーが全ユーザー情報を読み取れる（プロフィール表示用）
CREATE POLICY "Users are viewable by everyone"
ON "User"
FOR SELECT
USING (true);

-- ユーザーは自分自身のデータのみ更新可能
CREATE POLICY "Users can update own profile"
ON "User"
FOR UPDATE
USING (auth.uid()::text = id)
WITH CHECK (auth.uid()::text = id);

-- ユーザーは自分自身のデータのみ削除可能
CREATE POLICY "Users can delete own profile"
ON "User"
FOR DELETE
USING (auth.uid()::text = id);

-- 新規ユーザー作成はSupabase Authと連携して自動作成
-- （backend/prisma/seed.ts または backend/app/api/auth/signup/route.ts で実装）
CREATE POLICY "Users can insert own profile"
ON "User"
FOR INSERT
WITH CHECK (auth.uid()::text = id);

-- ===================================================================
-- 3. Post テーブルのポリシー
-- ===================================================================

-- 全ユーザーが全投稿を読み取れる
CREATE POLICY "Posts are viewable by everyone"
ON "Post"
FOR SELECT
USING (true);

-- ログインユーザーのみ投稿作成可能
CREATE POLICY "Authenticated users can create posts"
ON "Post"
FOR INSERT
WITH CHECK (auth.uid()::text = author_id);

-- ユーザーは自分の投稿のみ更新可能
CREATE POLICY "Users can update own posts"
ON "Post"
FOR UPDATE
USING (auth.uid()::text = author_id)
WITH CHECK (auth.uid()::text = author_id);

-- ユーザーは自分の投稿のみ削除可能
CREATE POLICY "Users can delete own posts"
ON "Post"
FOR DELETE
USING (auth.uid()::text = author_id);

-- ===================================================================
-- 4. 管理者用ポリシー（オプション）
-- ===================================================================

-- 管理者テーブルを作成する場合
-- CREATE TABLE "Admin" (
--   id UUID PRIMARY KEY REFERENCES auth.users(id),
--   email TEXT NOT NULL UNIQUE,
--   created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
-- );
--
-- ALTER TABLE "Admin" ENABLE ROW LEVEL SECURITY;
--
-- 管理者は全データにアクセス可能
-- CREATE POLICY "Admins can do anything"
-- ON "User"
-- USING (
--   EXISTS (
--     SELECT 1 FROM "Admin"
--     WHERE id = auth.uid()::text
--   )
-- );

-- ===================================================================
-- 5. ポリシーの確認
-- ===================================================================

-- 以下のクエリで設定したポリシーを確認できます:
-- SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
-- FROM pg_policies
-- WHERE schemaname = 'public';

-- ===================================================================
-- 6. 注意事項
-- ===================================================================

-- ⚠️ RLSを有効化すると、Supabase Service Role Keyを使わない限り、
--    これらのポリシーが全てのデータアクセスに適用されます。
--
-- ⚠️ Backend APIでSupabase Service Role Keyを使用する場合、
--    RLSポリシーはバイパスされます（backend/lib/auth/supabase.ts の supabaseAdmin）
--
-- ⚠️ 本番環境ではさらに厳格なポリシーを設定することを推奨します。
--    例: ユーザーのメールアドレスやパスワードハッシュを隠す

-- ===================================================================
-- 7. ポリシーの削除・無効化（トラブルシューティング用）
-- ===================================================================

-- ポリシーを削除する場合:
-- DROP POLICY "Users are viewable by everyone" ON "User";
-- DROP POLICY "Users can update own profile" ON "User";
-- DROP POLICY "Users can delete own profile" ON "User";
-- DROP POLICY "Users can insert own profile" ON "User";
--
-- DROP POLICY "Posts are viewable by everyone" ON "Post";
-- DROP POLICY "Authenticated users can create posts" ON "Post";
-- DROP POLICY "Users can update own posts" ON "Post";
-- DROP POLICY "Users can delete own posts" ON "Post";

-- RLSを無効化する場合（開発中のみ推奨）:
-- ALTER TABLE "User" DISABLE ROW LEVEL SECURITY;
-- ALTER TABLE "Post" DISABLE ROW LEVEL SECURITY;

-- ===================================================================
-- 8. カスタムポリシー例
-- ===================================================================

-- 例1: プライベート投稿機能（is_privateフィールドがある場合）
-- CREATE POLICY "Private posts visible only to author"
-- ON "Post"
-- FOR SELECT
-- USING (
--   NOT is_private OR auth.uid()::text = author_id
-- );

-- 例2: フォロワーのみ閲覧可能
-- CREATE POLICY "Posts visible to followers"
-- ON "Post"
-- FOR SELECT
-- USING (
--   EXISTS (
--     SELECT 1 FROM "Follow"
--     WHERE follower_id = auth.uid()::text
--     AND following_id = "Post".author_id
--   )
--   OR auth.uid()::text = author_id
-- );
