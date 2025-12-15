# Claude Code プロジェクト設定

このファイルは **[プロジェクト名]** 専用のClaude Code設定です。

---

## プロジェクト概要

**プロジェクト名**: [プロジェクト名を記入]
**種別**: [アプリの種類を記入 例: ECサイト、SaaS、管理画面等]
**フロントエンド**: Next.js (App Router)
**バックエンド**: Next.js API Routes
**BaaS**: Supabase (PostgreSQL, Auth, Storage, Realtime)
**スタイリング**: Tailwind CSS
**その他**: [追加の技術スタックがあれば記入]

---

## アーキテクチャ方針

このプロジェクトは**Next.js モノリス構成**を採用しています。

### データアクセス方法

#### 1. Server Components から直接 Supabase（推奨）
```
Server Component → Supabase
```
- 適用: データ取得、初期表示
- メリット: SEO対応、初回ロード高速、セキュア

#### 2. Client Components から Supabase
```
Client Component → Supabase
```
- 適用: リアルタイム更新、インタラクティブな操作
- メリット: リアルタイム、ユーザー体験向上

#### 3. API Routes 経由（複雑な処理）
```
Client → API Routes → Supabase / External APIs
```
- 適用: 外部API連携、複雑なビジネスロジック、Webhook
- メリット: セキュア、ロジック集約

---

## ディレクトリ構成

```
nextjs-fullstack/
├── app/                          # Next.js App Router
│   ├── api/                      # API Routes
│   ├── (auth)/                   # 認証関連ページ（グループ）
│   │   ├── login/
│   │   ├── register/
│   │   └── layout.tsx
│   ├── (main)/                   # メインページ（グループ）
│   │   ├── dashboard/
│   │   └── layout.tsx
│   ├── layout.tsx                # ルートレイアウト
│   └── page.tsx                  # ホームページ
├── components/                   # UIコンポーネント
│   ├── ui/                       # 基本UIコンポーネント
│   └── features/                 # 機能別コンポーネント
├── lib/                          # ユーティリティ
│   ├── supabase/                 # Supabaseクライアント
│   ├── db/                       # Prismaクライアント
│   └── utils/                    # 汎用ユーティリティ
├── prisma/                       # Prisma設定
├── types/                        # 型定義
├── docs/                         # ドキュメント
├── scripts/                      # 自動化スクリプト
└── templates/                    # コードテンプレート
```

---

## ドキュメント構成

### docs/requirements/ - 機能要件定義
各機能の**ビジネス要件のみ**を記載。技術的な実装詳細は含めない。

機能ごとにファイルを作成してください。例:
- `_TEMPLATE.md`: 要件定義テンプレート（コピーして使用）
- `user-profile.md`: ユーザープロフィール仕様
- `authentication.md`: 認証システム仕様
- `core-feature.md`: コア機能仕様
- `premium-features.md`: プレミアム機能・課金仕様

### docs/design/ - 技術設計
システム全体の技術的な設計を記載。

#### docs/design/database/
- `overall-schema.md`: データベース全体設計（Prismaスキーマ、ER図）

#### docs/design/api/
- `endpoints.md`: REST APIエンドポイント一覧

#### docs/design/architecture/
- `system-architecture.md`: システムアーキテクチャ全体像
- `directory-structure.md`: ディレクトリ構成

#### docs/design/ui-ux/
- `screen-list.md`: 画面一覧
- `screen-details.md`: 画面詳細設計

### docs/project-management/ - プロジェクト管理
- `implementation-phases.md`: 実装フェーズ計画
- `coding-standards.md`: コーディング規約

---

## 自動化ツール・スクリプト

### scripts/setup-dev-env.sh
開発環境のワンコマンドセットアップ

### scripts/generate-feature.sh
新機能のボイラープレートコード自動生成

### scripts/validate-project.sh
プロジェクト設計の完全性チェック

---

## コーディング規約

### TypeScript
- インデント: 2スペース
- 命名: camelCase (変数・関数), PascalCase (クラス・型・コンポーネント)
- `any`型禁止 (unknownまたは具体的な型を使用)
- ファイル名: kebab-case.ts / PascalCase.tsx (コンポーネント)
- セミコロン必須

### React / Next.js
- Server Components をデフォルトで使用
- 'use client' は必要な場合のみ
- コンポーネントは関数コンポーネントで記述
- Props は interface で定義

---

## コミットメッセージ規約

**フォーマット**:
```
<type>: <subject>

<body>
```

**Type**:
- `feat`: 新機能追加
- `fix`: バグ修正
- `refactor`: リファクタリング
- `docs`: ドキュメント更新
- `test`: テスト追加・修正
- `chore`: その他の変更
- `perf`: パフォーマンス改善

**必須**: コミットメッセージは日本語で記述

---

## 実装フェーズ

現在: **Phase 0 - 設計フェーズ**

基本的なフェーズ例:
- Phase 0: 設計フェーズ（要件定義、DB設計、API設計）
- Phase 1: 基盤構築（Next.js、Supabase、認証）
- Phase 2: コア機能実装
- Phase 3: 追加機能実装
- Phase 4: テスト・デバッグ
- Phase 5: リリース準備

---

## 重要な設計原則

### 1. Server Components First
- データ取得は Server Components で
- インタラクティブな部分のみ Client Components

### 2. 型変更時の影響範囲チェック
データベーススキーマやモデルの型を変更する際は、**必ず以下の全ての箇所を同期する**:

1. `prisma/schema.prisma` - Prismaスキーマ
2. `types/index.ts` - TypeScript型定義
3. `docs/design/database/overall-schema.md` - データベース設計書

### 3. セキュリティ
- `any`型は絶対に使用禁止
- 認証はSupabase Authを使用
- Row Level Security (RLS)を必ず有効化
- Service Role Keyは環境変数で管理、公開禁止

---

## プロジェクト開始チェックリスト

1. **テンプレートをコピー**
   ```bash
   cp -r nextjs-fullstack /path/to/new-project
   cd /path/to/new-project
   git init
   ```

2. **開発環境セットアップ**
   ```bash
   ./scripts/setup-dev-env.sh
   ```

3. **プロジェクト情報をカスタマイズ**
   - [ ] `.claude/CLAUDE.md`のプロジェクト名、種別を記入
   - [ ] `.claude/hooks/`をカスタマイズ

4. **Phase 0: 設計フェーズ**
   - [ ] 要件定義を作成
   - [ ] データベース設計
   - [ ] API設計
   - [ ] 画面設計

5. **設計完了チェック**
   ```bash
   ./scripts/validate-project.sh
   ```

---

**最終更新日**: 2025-12-15
