# Backend (Next.js)

このディレクトリには、Next.js App Routerを使用したBackend APIが含まれています。

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
│   └── auth/             # 認証関連
├── middleware/           # ミドルウェア
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

```bash
# 依存関係インストール
npm install

# 環境変数設定
cp .env.example .env
# .env を編集してデータベースURL等を設定

# Prisma生成
npm run prisma:generate

# データベースプッシュ
npm run prisma:push

# シードデータ投入（オプション）
npm run prisma:seed

# 開発サーバー起動
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

JWT Access Token + Refresh Tokenを使用。

- Access Token: 15分
- Refresh Token: 30日

詳細は `docs/requirements/authentication.md` を参照してください。
