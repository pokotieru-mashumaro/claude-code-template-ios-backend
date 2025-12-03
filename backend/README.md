# Backend (Next.js + Supabase)

このディレクトリには、Next.js App Router + Supabaseを使用したBackend APIが含まれています。

## ディレクトリ構成

```
backend/
├── app/
│   ├── api/              # APIエンドポイント
│   │   └── [resource]/   # リソースごとのAPI
│   ├── layout.tsx        # ルートレイアウト
│   └── page.tsx          # トップページ
├── lib/
│   ├── db/
│   │   └── prisma.ts     # Prisma Client設定
│   └── auth/
│       └── supabase.ts   # Supabase Client設定
├── middleware/
│   └── supabase-auth.ts  # Supabase認証ミドルウェア
├── types/
│   └── index.ts          # TypeScript型定義
├── prisma/
│   ├── schema.prisma     # Prismaスキーマ
│   └── seed.ts           # シードデータ
├── __tests__/            # テストファイル
├── package.json
├── tsconfig.json
├── next.config.js
└── .env.example          # 環境変数テンプレート
```

## セットアップ

### 1. Supabaseプロジェクト作成

1. [Supabaseダッシュボード](https://supabase.com/dashboard)でプロジェクト作成
2. Settings > API から以下を取得:
   - Project URL
   - anon/public key
   - service_role key (秘密)
3. Settings > Database > Connection string から Database URL を取得

### 2. 環境変数設定

```bash
# 依存関係インストール
npm install

# 環境変数設定
cp .env.example .env
# .env を編集してSupabase設定を記入
```

### 3. データベースセットアップ

```bash
# Prisma生成
npm run prisma:generate

# データベースプッシュ
npm run prisma:push

# シードデータ投入（オプション）
npm run prisma:seed
```

### 4. 開発サーバー起動

```bash
npm run dev
```

## 開発コマンド

```bash
# 開発サーバー起動
npm run dev

# 型チェック
npm run type-check

# Lint
npm run lint

# テスト
npm run test

# Prisma Studio（DBビューア）
npm run prisma:studio
```

## API設計

詳細は `docs/design/api/endpoints.md` を参照してください。

### レスポンスフォーマット

**成功時**:
```json
{
  "success": true,
  "data": { ... }
}
```

**エラー時**:
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "エラーメッセージ",
    "details": { ... }
  }
}
```

## 認証

Supabase Authを使用。

- メール/パスワード認証
- ソーシャルログイン（Google、GitHub等）
- Magic Link
- JWT自動管理

### 認証の使い方

```typescript
// クライアントサイド
import { supabaseClient } from '@/lib/auth/supabase';

// サインアップ
const { data, error } = await supabaseClient.auth.signUp({
  email: 'user@example.com',
  password: 'password',
});

// ログイン
const { data, error } = await supabaseClient.auth.signInWithPassword({
  email: 'user@example.com',
  password: 'password',
});

// ログアウト
await supabaseClient.auth.signOut();
```

### 認証ミドルウェア

```typescript
import { withSupabaseAuth } from '@/middleware/supabase-auth';

export const GET = withSupabaseAuth(async (req) => {
  const userId = req.user?.id;
  // 認証済みユーザーのみアクセス可能
});
```

詳細は `docs/requirements/authentication.md` を参照してください。
