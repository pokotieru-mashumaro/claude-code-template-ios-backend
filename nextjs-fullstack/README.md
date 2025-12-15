# Next.js Fullstack テンプレート

Next.js (App Router) + Supabase を使用したフルスタックWebアプリケーションテンプレートです。

## 技術スタック

- **フレームワーク**: Next.js 14 (App Router)
- **言語**: TypeScript
- **スタイリング**: Tailwind CSS
- **データベース**: Supabase PostgreSQL
- **ORM**: Prisma
- **認証**: Supabase Auth

## 特徴

- Server Components First アーキテクチャ
- 型安全な開発（`any`型禁止）
- Supabase SSR 対応
- Row Level Security (RLS) 対応
- CI/CD 設定済み

## セットアップ

```bash
# 1. テンプレートをコピー
cp -r nextjs-fullstack /path/to/my-project
cd /path/to/my-project

# 2. Git初期化
git init

# 3. 開発環境セットアップ
./scripts/setup-dev-env.sh

# 4. 環境変数を設定
# .env.local を編集してSupabaseの設定を入力

# 5. 開発サーバー起動
npm run dev
```

## ディレクトリ構成

```
nextjs-fullstack/
├── app/                  # Next.js App Router
│   ├── api/              # API Routes
│   ├── (auth)/           # 認証ページ
│   └── (main)/           # メインページ
├── components/           # UIコンポーネント
├── lib/                  # ユーティリティ
├── prisma/               # Prisma設定
├── types/                # 型定義
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

## スクリプト

- `npm run dev` - 開発サーバー起動
- `npm run build` - ビルド
- `npm run lint` - Lint実行
- `npm run type-check` - 型チェック
- `npm run test` - テスト実行
