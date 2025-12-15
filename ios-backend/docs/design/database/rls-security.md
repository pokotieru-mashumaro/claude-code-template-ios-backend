# Row Level Security (RLS) 設計

Supabase PostgreSQLのRow Level Security (RLS) を使用したデータアクセス制御。

## RLSとは

Row Level Security (行レベルセキュリティ) は、PostgreSQLの機能で、テーブルの各行に対してアクセス制御を設定できます。

### メリット

- **データベースレベルでのセキュリティ**: アプリケーションコードのバグがあってもデータ漏洩を防げる
- **宣言的**: SQLポリシーで明確にアクセス権限を定義
- **パフォーマンス**: データベース内で直接フィルタリングされるため高速

## RLSポリシー設定

`backend/prisma/rls-policies.sql` に全てのRLSポリシーを定義しています。

### セットアップ手順

1. Supabaseダッシュボードにログイン
2. **SQL Editor** を開く
3. `backend/prisma/rls-policies.sql` の内容をコピー&ペースト
4. 実行

## ポリシー一覧

### User テーブル

| ポリシー名 | 操作 | 条件 | 説明 |
|-----------|------|------|------|
| `Users are viewable by everyone` | SELECT | `true` | 全ユーザーが全ユーザー情報を閲覧可能 |
| `Users can update own profile` | UPDATE | `auth.uid() = id` | ユーザーは自分のプロフィールのみ更新可能 |
| `Users can delete own profile` | DELETE | `auth.uid() = id` | ユーザーは自分のアカウントのみ削除可能 |
| `Users can insert own profile` | INSERT | `auth.uid() = id` | ユーザー作成時にauth.uid()と一致するIDのみ挿入可能 |

### Post テーブル

| ポリシー名 | 操作 | 条件 | 説明 |
|-----------|------|------|------|
| `Posts are viewable by everyone` | SELECT | `true` | 全ユーザーが全投稿を閲覧可能 |
| `Authenticated users can create posts` | INSERT | `auth.uid() = author_id` | ログインユーザーのみ投稿作成可能 |
| `Users can update own posts` | UPDATE | `auth.uid() = author_id` | ユーザーは自分の投稿のみ更新可能 |
| `Users can delete own posts` | DELETE | `auth.uid() = author_id` | ユーザーは自分の投稿のみ削除可能 |

## auth.uid() とは

Supabaseが提供する関数で、現在ログイン中のユーザーのUUIDを返します。

```sql
-- 現在のユーザーID取得
SELECT auth.uid();

-- 例: '550e8400-e29b-41d4-a716-446655440000'::uuid
```

### 型変換に注意

PrismaスキーマではIDを`String`型で定義していますが、Supabaseの`auth.uid()`は`UUID`型を返すため、型変換が必要です：

```sql
-- ✅ 正しい
auth.uid()::text = id

-- ❌ 間違い（型不一致エラー）
auth.uid() = id
```

## Service Role Key によるバイパス

Backend APIで `supabaseAdmin` (Service Role Key使用) を使う場合、**RLSポリシーは全てバイパスされます**。

```typescript
import { supabaseAdmin } from '@/lib/auth/supabase';

// RLSポリシーを無視してアクセス可能
const { data } = await supabaseAdmin
  .from('User')
  .select('*')
  .execute();
```

### 使い分け

| クライアント | キー | RLS適用 | 用途 |
|------------|------|--------|------|
| `supabaseClient` | Anon Key | ✅ 適用される | フロントエンド、一般ユーザー操作 |
| `supabaseAdmin` | Service Role Key | ❌ バイパス | バックエンド、管理者操作 |

## ポリシーのテスト

### SQL Editorでテスト

```sql
-- 1. テストユーザーでログイン（Supabase Auth UIを使用）

-- 2. 現在のユーザーID確認
SELECT auth.uid();

-- 3. 自分のユーザー情報取得（成功するはず）
SELECT * FROM "User" WHERE id = auth.uid()::text;

-- 4. 他人のユーザー情報更新（失敗するはず）
UPDATE "User"
SET name = 'ハッカー'
WHERE id = '<他人のユーザーID>';
-- => エラー: new row violates row-level security policy
```

### APIでテスト

```bash
# 1. ログイン
curl -X POST https://your-project.supabase.co/auth/v1/token \
  -H "apikey: YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password"}'

# 2. アクセストークン取得（レスポンスのaccess_token）

# 3. 自分のプロフィール更新（成功）
curl -X PATCH https://your-project.supabase.co/rest/v1/User?id=eq.YOUR_USER_ID \
  -H "apikey: YOUR_ANON_KEY" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"新しい名前"}'

# 4. 他人のプロフィール更新（失敗）
curl -X PATCH https://your-project.supabase.co/rest/v1/User?id=eq.OTHER_USER_ID \
  -H "apikey: YOUR_ANON_KEY" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"ハッカー"}'
# => エラー
```

## カスタムポリシー例

### プライベート投稿

```sql
ALTER TABLE "Post" ADD COLUMN is_private BOOLEAN DEFAULT false;

CREATE POLICY "Private posts visible only to author"
ON "Post"
FOR SELECT
USING (
  NOT is_private OR auth.uid()::text = author_id
);
```

### フォロワーのみ閲覧可能

```sql
CREATE TABLE "Follow" (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  follower_id UUID NOT NULL REFERENCES auth.users(id),
  following_id UUID NOT NULL REFERENCES auth.users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(follower_id, following_id)
);

CREATE POLICY "Posts visible to followers"
ON "Post"
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM "Follow"
    WHERE follower_id = auth.uid()
    AND following_id = "Post".author_id
  )
  OR auth.uid()::text = author_id
  OR NOT is_private
);
```

### 管理者は全てアクセス可能

```sql
CREATE TABLE "Admin" (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  email TEXT NOT NULL UNIQUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE "Admin" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can do anything on User"
ON "User"
USING (
  EXISTS (
    SELECT 1 FROM "Admin"
    WHERE id = auth.uid()
  )
);
```

## トラブルシューティング

### ポリシー違反エラー

```
new row violates row-level security policy for table "User"
```

**原因**: ポリシーの条件を満たさないデータを挿入・更新しようとした

**解決策**:
1. ポリシー条件を確認
2. `auth.uid()`が正しく設定されているか確認
3. Service Role Keyを使用している場合はAnon Keyに変更

### ポリシーが反映されない

**原因**: RLSが有効化されていない、またはポリシーが作成されていない

**解決策**:
```sql
-- RLS有効化確認
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public';

-- ポリシー確認
SELECT schemaname, tablename, policyname
FROM pg_policies
WHERE schemaname = 'public';
```

### 開発中にRLSを一時無効化したい

```sql
-- ⚠️ 開発環境のみ！本番では絶対にしない！
ALTER TABLE "User" DISABLE ROW LEVEL SECURITY;
ALTER TABLE "Post" DISABLE ROW LEVEL SECURITY;
```

## セキュリティベストプラクティス

### ✅ DO

- 全てのテーブルでRLSを有効化
- `auth.uid()`を使って現在のユーザーを識別
- Service Role Keyは環境変数で管理し、公開しない
- ポリシーは最小権限の原則で設計

### ❌ DON'T

- RLSを無効化したまま本番デプロイ
- Service Role Keyをフロントエンドに埋め込む
- `USING (true)` でINSERT/UPDATE/DELETEを許可
- ポリシーなしで機密情報を保存

## 参考資料

- [Supabase RLS Documentation](https://supabase.com/docs/guides/auth/row-level-security)
- [PostgreSQL Row Security Policies](https://www.postgresql.org/docs/current/ddl-rowsecurity.html)
