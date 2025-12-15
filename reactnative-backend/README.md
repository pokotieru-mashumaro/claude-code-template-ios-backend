# React Native + Backend テンプレート

React Native (Expo) + Next.js Backend + Supabase を使用したモバイルアプリテンプレートです。

## 技術スタック

### Mobile
- **フレームワーク**: React Native (Expo)
- **ナビゲーション**: Expo Router
- **言語**: TypeScript

### Backend
- **フレームワーク**: Next.js 14 (App Router)
- **言語**: TypeScript
- **ORM**: Prisma

### 共通
- **BaaS**: Supabase (PostgreSQL, Auth, Storage, Realtime)

## 特徴

- ハイブリッドアーキテクチャ（直接Supabase or Backend経由）
- 型安全な開発（`any`型禁止）
- SecureStore によるセキュアなトークン管理
- CI/CD 設定済み

## セットアップ

```bash
# 1. テンプレートをコピー
cp -r reactnative-backend /path/to/my-project
cd /path/to/my-project

# 2. Git初期化
git init

# 3. 開発環境セットアップ
./scripts/setup-dev-env.sh

# 4. 環境変数を設定
# backend/.env.local と mobile/.env を編集

# 5. 開発サーバー起動
# Backend
cd backend && npm run dev

# Mobile (別ターミナル)
cd mobile && npm start
```

## ディレクトリ構成

```
reactnative-backend/
├── backend/              # Next.js Backend
│   ├── app/api/          # API Routes
│   ├── lib/              # ユーティリティ
│   ├── prisma/           # Prisma設定
│   └── types/            # 型定義
│
├── mobile/               # React Native (Expo)
│   ├── app/              # Expo Router
│   ├── components/       # UIコンポーネント
│   ├── lib/              # ユーティリティ
│   └── hooks/            # カスタムフック
│
├── docs/                 # ドキュメント
└── scripts/              # 自動化スクリプト
```

## 開発の流れ

1. `docs/requirements/` に要件定義を作成
2. `docs/design/` に技術設計を作成
3. `./scripts/validate-project.sh` で設計をチェック
4. 実装開始

## ドキュメント

- [アーキテクチャ](docs/design/architecture/system-architecture.md)
- [API設計](docs/design/api/endpoints.md)
- [データベース設計](docs/design/database/overall-schema.md)
