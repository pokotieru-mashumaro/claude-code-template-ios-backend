# Claude Code プロジェクト設定

このファイルは **[プロジェクト名]** 専用のClaude Code設定です。

---

## プロジェクト概要

**プロジェクト名**: [プロジェクト名を記入]
**種別**: [アプリの種類を記入 例: マッチングアプリ、ECサイト、SNS等]
**フロントエンド**: React Native (Expo)
**バックエンド**: Next.js (TypeScript) + Supabase
**BaaS**: Supabase (PostgreSQL, Auth, Storage, Realtime)
**その他**: [追加の技術スタックがあれば記入]

---

## アーキテクチャ方針

このプロジェクトは**ハイブリッドアーキテクチャ**を採用しています。

### モバイルアプリのデータアクセス方法

#### 1. 直接Supabaseにアクセス（シンプルなCRUD）
```
React Native App → Supabase
```
- 適用: ユーザープロフィール取得・更新、投稿CRUD、リアルタイム機能
- メリット: 低レイテンシ、低コスト、シンプル

#### 2. Next.js Backend経由でアクセス（複雑な処理）
```
React Native App → Next.js Backend → Supabase
```
- 適用: 外部API連携（Stripe、OpenAI等）、管理者機能、複雑なビジネスロジック
- メリット: セキュア、ロジック集約、RLSバイパス可能

#### 3. ハイブリッド（推奨）
```
React Native App
  ├─ 単純なCRUD → 直接Supabase
  └─ 複雑な処理 → Next.js Backend → Supabase
```

---

## ディレクトリ構成

```
reactnative-backend/
├── backend/                      # Next.js Backend
│   ├── app/api/                  # API Routes
│   ├── lib/                      # ユーティリティ
│   ├── middleware/               # ミドルウェア
│   ├── prisma/                   # Prisma設定
│   └── types/                    # 型定義
│
├── mobile/                       # React Native (Expo)
│   ├── app/                      # Expo Router
│   ├── components/               # UIコンポーネント
│   ├── lib/                      # ユーティリティ
│   └── hooks/                    # カスタムフック
│
├── docs/                         # ドキュメント
├── scripts/                      # 自動化スクリプト
└── templates/                    # コードテンプレート
```

---

## ドキュメント構成

### docs/requirements/ - 機能要件定義
各機能の**ビジネス要件のみ**を記載。

### docs/design/ - 技術設計
- `database/`: データベース設計
- `api/`: API設計
- `architecture/`: アーキテクチャ設計
- `ui-ux/`: 画面設計

### docs/project-management/ - プロジェクト管理
- `implementation-phases.md`: 実装フェーズ計画
- `coding-standards.md`: コーディング規約

---

## コーディング規約

### TypeScript (Backend & Mobile)
- インデント: 2スペース
- 命名: camelCase (変数・関数), PascalCase (クラス・型・コンポーネント)
- `any`型禁止 (unknownまたは具体的な型を使用)
- ファイル名: kebab-case.ts / PascalCase.tsx (コンポーネント)
- セミコロン必須

### React Native
- 関数コンポーネントを使用
- StyleSheet.create でスタイル定義
- カスタムフックで状態管理

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

**必須**: コミットメッセージは日本語で記述

---

## 実装フェーズ

現在: **Phase 0 - 設計フェーズ**

基本的なフェーズ例:
- Phase 0: 設計フェーズ（要件定義、DB設計、API設計）
- Phase 1: バックエンド基盤構築（Next.js、Supabase、認証）
- Phase 2: モバイル基盤構築（Expo、ナビゲーション、認証）
- Phase 3: コア機能実装
- Phase 4: 追加機能実装
- Phase 5: テスト・デバッグ
- Phase 6: リリース準備

---

## 重要な設計原則

### 1. 型変更時の影響範囲チェック
データベーススキーマやモデルの型を変更する際は、**必ず以下の全ての箇所を同期する**:

1. `backend/prisma/schema.prisma` - Prismaスキーマ
2. `backend/types/index.ts` - Backend型定義
3. `mobile/lib/types.ts` - Mobile型定義（必要に応じて作成）
4. `docs/design/database/overall-schema.md` - 設計書

### 2. セキュリティ
- `any`型は絶対に使用禁止
- 認証はSupabase Authを使用
- Row Level Security (RLS)を必ず有効化
- Service Role Keyは環境変数で管理、公開禁止
- SecureStore でトークン管理

---

## プロジェクト開始チェックリスト

1. **テンプレートをコピー**
   ```bash
   cp -r reactnative-backend /path/to/new-project
   cd /path/to/new-project
   git init
   ```

2. **開発環境セットアップ**
   ```bash
   ./scripts/setup-dev-env.sh
   ```

3. **プロジェクト情報をカスタマイズ**
   - [ ] `.claude/CLAUDE.md`のプロジェクト名、種別を記入
   - [ ] `mobile/app.json` のプロジェクト名を変更

4. **Phase 0: 設計フェーズ**
   - [ ] 要件定義を作成
   - [ ] データベース設計
   - [ ] API設計
   - [ ] 画面設計

---

**最終更新日**: 2025-12-15
