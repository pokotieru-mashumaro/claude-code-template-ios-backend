# Claude Code Templates

Claude Code を使用したプロジェクト開発用のテンプレート集です。

## テンプレート一覧

| テンプレート | フロントエンド | バックエンド | 説明 |
|-------------|---------------|-------------|------|
| [ios-backend](./ios-backend/) | iOS (SwiftUI) | Next.js + Supabase | iOSネイティブアプリ + API |
| [nextjs-fullstack](./nextjs-fullstack/) | Next.js (App Router) | Next.js API Routes + Supabase | Webアプリ（モノリス） |
| [reactnative-backend](./reactnative-backend/) | React Native (Expo) | Next.js + Supabase | クロスプラットフォームモバイルアプリ |

## 使い方

### 1. テンプレートをコピー

```bash
# 例: ios-backend テンプレートを使用
cp -r ios-backend /path/to/my-new-project
cd /path/to/my-new-project
```

### 2. Git を初期化

```bash
git init
git add .
git commit -m "feat: 初期セットアップ"
```

### 3. 開発環境をセットアップ

```bash
./scripts/setup-dev-env.sh
```

### 4. プロジェクト情報をカスタマイズ

- `.claude/CLAUDE.md` のプロジェクト名、種別を記入
- 環境変数ファイル（`.env` / `.env.local`）を設定

## テンプレート詳細

### ios-backend

**対象**: iOSネイティブアプリを開発したい場合

**技術スタック**:
- iOS: SwiftUI, Clean Architecture
- Backend: Next.js, Prisma, Supabase

**特徴**:
- ハイブリッドアーキテクチャ（直接Supabase or Backend経由）
- 型同期チェック（Swift ↔ TypeScript）
- SwiftUI + MVVM

---

### nextjs-fullstack

**対象**: Webアプリを開発したい場合

**技術スタック**:
- Frontend: Next.js (App Router), Tailwind CSS
- Backend: Next.js API Routes, Prisma, Supabase

**特徴**:
- Server Components First
- モノリス構成（フロント + API が同一プロジェクト）
- SSR / SSG 対応

---

### reactnative-backend

**対象**: iOS / Android 両対応のモバイルアプリを開発したい場合

**技術スタック**:
- Mobile: React Native (Expo), Expo Router
- Backend: Next.js, Prisma, Supabase

**特徴**:
- クロスプラットフォーム（iOS / Android / Web）
- Expo による開発効率化
- SecureStore によるセキュアなトークン管理

## 共通の特徴

すべてのテンプレートに共通する特徴:

- **Supabase 統合**: PostgreSQL, Auth, Storage, Realtime
- **型安全**: `any`型禁止、TypeScript / Swift の厳格な型チェック
- **CI/CD**: GitHub Actions 設定済み
- **ドキュメント駆動**: 要件定義 → 技術設計 → 実装 のフロー
- **Claude Code Hooks**: 自動整合性チェック

## ディレクトリ構成（共通）

各テンプレートは以下の構成を持ちます:

```
template/
├── .claude/              # Claude Code 設定
│   ├── CLAUDE.md         # プロジェクト設定
│   └── hooks/            # 自動チェックスクリプト
├── .github/workflows/    # CI/CD
├── docs/                 # ドキュメント
│   ├── requirements/     # 要件定義
│   ├── design/           # 技術設計
│   └── project-management/
├── scripts/              # 自動化スクリプト
├── templates/            # コードテンプレート
└── README.md
```

## 開発フロー

1. **Phase 0: 設計**
   - `docs/requirements/` に要件定義を作成
   - `docs/design/` に技術設計を作成
   - `./scripts/validate-project.sh` で設計をチェック

2. **Phase 1〜: 実装**
   - 設計に基づいて実装
   - `./scripts/generate-feature.sh` で機能を生成（対応テンプレートのみ）

## ライセンス

MIT
