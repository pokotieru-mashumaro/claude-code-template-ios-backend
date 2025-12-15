# Supabase セットアップガイド

このプロジェクトはSupabaseをBaaS (Backend as a Service) として使用します。

## 前提条件

- GitHubアカウント
- Supabaseアカウント（無料プランでOK）

## 1. Supabaseプロジェクト作成

### 1.1 Supabaseにサインアップ

1. [Supabase](https://supabase.com/) にアクセス
2. "Start your project" をクリック
3. GitHubアカウントでサインイン

### 1.2 新規プロジェクト作成

1. ダッシュボードの "New Project" をクリック
2. 以下を入力：
   - **Name**: プロジェクト名（例: `my-app-production`）
   - **Database Password**: 強力なパスワードを生成（**メモしておく**）
   - **Region**: `Northeast Asia (Tokyo)` または最寄りのリージョン
   - **Pricing Plan**: Free（開発時）
3. "Create new project" をクリック
4. プロジェクト作成完了まで1-2分待つ

## 2. 環境変数の取得

### 2.1 APIキーの取得

1. Supabaseダッシュボードで作成したプロジェクトを開く
2. 左サイドバーの **Settings** (歯車アイコン) をクリック
3. **API** をクリック
4. 以下の値をコピー：
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon public**: `eyJhbGc...`（公開用キー）
   - **service_role**: `eyJhbGc...`（サーバー用キー、⚠️ 絶対に公開しない）

### 2.2 データベース接続文字列の取得

1. 左サイドバーの **Settings** > **Database** をクリック
2. **Connection string** セクションの **URI** タブを選択
3. `postgresql://postgres:[YOUR-PASSWORD]@db.xxxxx.supabase.co:5432/postgres` をコピー
4. `[YOUR-PASSWORD]` を1.2でメモしたパスワードに置き換える

### 2.3 Direct URL の取得

1. 同じ **Connection string** セクションで **Connection pooling** の `Mode` を `Session` に設定
2. 表示されるURLをコピー（`postgresql://postgres.xxxxx:[YOUR-PASSWORD]@aws-0-ap-northeast-1.pooler.supabase.com:5432/postgres`）

## 3. Backend環境変数設定

### 3.1 .env.local ファイル作成

```bash
cd backend
cp .env.example .env.local
```

### 3.2 .env.local を編集

```env
# Supabase設定
NEXT_PUBLIC_SUPABASE_URL="https://xxxxx.supabase.co"
NEXT_PUBLIC_SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
SUPABASE_SERVICE_ROLE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

# Prisma Database URL
DATABASE_URL="postgresql://postgres:[YOUR-PASSWORD]@db.xxxxx.supabase.co:5432/postgres"
DIRECT_URL="postgresql://postgres.xxxxx:[YOUR-PASSWORD]@aws-0-ap-northeast-1.pooler.supabase.com:5432/postgres"
```

⚠️ **重要**: `.env.local` は `.gitignore` に追加されているため、Gitにコミットされません。

## 4. データベースマイグレーション

### 4.1 Prismaスキーマをプッシュ

```bash
cd backend
npm install
npx prisma db push
```

成功すると、Supabaseデータベースに `User` と `Post` テーブルが作成されます。

### 4.2 テーブル確認

1. Supabaseダッシュボードで **Table Editor** を開く
2. `User` と `Post` テーブルが作成されていることを確認

## 5. Row Level Security (RLS) 設定

### 5.1 RLSポリシーを適用

1. Supabaseダッシュボードで **SQL Editor** を開く
2. `backend/prisma/rls-policies.sql` の内容をコピー
3. SQL Editorに貼り付けて **Run** をクリック
4. 成功メッセージを確認

### 5.2 RLS有効化確認

```sql
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
AND tablename IN ('User', 'Post');
```

`rowsecurity` が `true` になっていればOK。

詳細は [docs/design/database/rls-security.md](../design/database/rls-security.md) を参照。

## 6. テストデータ投入

```bash
cd backend
npx tsx prisma/seed.ts
```

テストユーザーと投稿が作成されます。

### デフォルトのテストユーザー

- **Email**: `test@example.com`
- **Password**: `password123`

## 7. iOS側の設定

### 7.1 Supabase認証情報を設定

iOSアプリで使用する場合、以下を設定：

#### 方法1: Info.plist

```xml
<key>SUPABASE_URL</key>
<string>https://xxxxx.supabase.co</string>
<key>SUPABASE_ANON_KEY</key>
<string>eyJhbGc...</string>
```

#### 方法2: Xcodeスキームの環境変数

1. Xcodeで Product > Scheme > Edit Scheme...
2. Run > Arguments > Environment Variables
3. 以下を追加：
   - `SUPABASE_URL`: `https://xxxxx.supabase.co`
   - `SUPABASE_ANON_KEY`: `eyJhbGc...`

## 8. GitHub Actions の設定（CI/CD）

### 8.1 GitHub Secrets に追加

1. GitHubリポジトリの **Settings** > **Secrets and variables** > **Actions** を開く
2. **New repository secret** をクリック
3. 以下のシークレットを追加：

| Name | Value |
|------|-------|
| `SUPABASE_DATABASE_URL` | `postgresql://postgres:[YOUR-PASSWORD]@db.xxxxx.supabase.co:5432/postgres` |
| `SUPABASE_DIRECT_URL` | `postgresql://postgres.xxxxx:[YOUR-PASSWORD]@aws-0-ap-northeast-1.pooler.supabase.com:5432/postgres` |
| `NEXT_PUBLIC_SUPABASE_URL` | `https://xxxxx.supabase.co` |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | `eyJhbGc...` |
| `SUPABASE_SERVICE_ROLE_KEY` | `eyJhbGc...` |

GitHub Actionsが自動的にこれらを使用します。

## 9. 動作確認

### 9.1 Backendサーバー起動

```bash
cd backend
npm run dev
```

`http://localhost:3000` でサーバーが起動します。

### 9.2 APIテスト

#### ユーザー一覧取得

```bash
curl http://localhost:3000/api/users
```

レスポンス例：
```json
{
  "success": true,
  "data": {
    "users": [
      {
        "id": "550e8400-e29b-41d4-a716-446655440000",
        "email": "test@example.com",
        "name": "テストユーザー",
        "createdAt": "2025-12-04T00:00:00.000Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 1,
      "totalPages": 1
    }
  }
}
```

### 9.3 認証テスト

#### ログイン

```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

レスポンス例：
```json
{
  "success": true,
  "data": {
    "session": {
      "access_token": "eyJhbGc...",
      "refresh_token": "...",
      "user": {
        "id": "550e8400-e29b-41d4-a716-446655440000",
        "email": "test@example.com"
      }
    }
  }
}
```

## 10. 本番環境用のプロジェクト作成

開発環境と本番環境で別のSupabaseプロジェクトを使用することを推奨します。

### 10.1 本番用プロジェクト作成

1. Supabaseダッシュボードで新しいプロジェクトを作成
2. プロジェクト名を `my-app-production` など明確に
3. リージョンを選択（エンドユーザーに近い場所）
4. 環境変数を `.env.production` に保存（Vercel等にデプロイ時に使用）

### 10.2 環境別の管理

| 環境 | ファイル | 用途 |
|------|---------|------|
| 開発 | `.env.local` | ローカル開発 |
| ステージング | `.env.staging` | テスト環境 |
| 本番 | `.env.production` | 本番環境（Vercel等） |

## 11. トラブルシューティング

### エラー: "Invalid API key"

**原因**: SUPABASE_ANON_KEY または SERVICE_ROLE_KEY が間違っている

**解決策**:
1. Supabase Dashboard > Settings > API で再確認
2. `.env.local` を再度確認

### エラー: "Connection refused"

**原因**: DATABASE_URL のパスワードが間違っている

**解決策**:
1. Supabase Dashboard > Settings > Database でパスワードをリセット
2. `.env.local` の `DATABASE_URL` と `DIRECT_URL` を更新
3. `npx prisma db push` を再実行

### エラー: "Schema validation failed"

**原因**: Prismaスキーマが正しくない

**解決策**:
```bash
npx prisma validate
npx prisma format
npx prisma db push
```

### RLSポリシーエラー

**エラー**: `new row violates row-level security policy`

**解決策**:
1. `backend/prisma/rls-policies.sql` を再度実行
2. Supabase SQL Editorで以下を実行して確認：
```sql
SELECT schemaname, tablename, policyname
FROM pg_policies
WHERE schemaname = 'public';
```

## 12. セキュリティチェックリスト

- [ ] `SUPABASE_SERVICE_ROLE_KEY` は `.env.local` にのみ保存（Gitにコミットしない）
- [ ] `.env.local` が `.gitignore` に含まれている
- [ ] RLSポリシーが全てのテーブルで有効化されている
- [ ] 本番環境のデータベースパスワードは強力（16文字以上、記号含む）
- [ ] GitHub Secretsに本番環境の認証情報を保存
- [ ] 開発環境と本番環境で別のSupabaseプロジェクトを使用

## 参考資料

- [Supabase公式ドキュメント](https://supabase.com/docs)
- [Prisma + Supabase](https://www.prisma.io/docs/guides/database/supabase)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
