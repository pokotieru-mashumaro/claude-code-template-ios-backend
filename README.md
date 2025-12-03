# iOS + Backend プロジェクトテンプレート（Claude Code用）

このテンプレートは、**iOS (SwiftUI) + Next.js Backend** の構成でアプリケーションを開発する際に、Claude Codeが効率的に作業できるように設計されたプロジェクトテンプレートです。

---

## 📋 特徴

### コア機能
- ✅ **iOS + Backend統合開発**に最適化された構成
- ✅ **Clean Architecture**によるiOS設計
- ✅ **型安全性**を重視（Swift/TypeScript共に`any`型禁止）
- ✅ **自動整合性チェック**（要件定義、DB、型定義）
- ✅ **包括的なドキュメントテンプレート**
- ✅ **Claude Code Hooks**による品質担保

### 🚀 NEW! 高度な機能
- ✨ **自動コード生成**: 機能追加時のボイラープレート自動生成
- 🔧 **開発環境ワンコマンドセットアップ**: 依存関係の自動インストール
- 🤖 **CI/CD完備**: GitHub Actions（Backend/iOS/Docs）
- ✅ **プロジェクト検証**: Phase 0完了チェック自動化
- 📝 **コードテンプレート**: API/UI/ViewModelのテンプレート完備
- 🔍 **セキュリティスキャン**: npm audit + secrets検出

---

## 🏗️ 技術スタック

### iOS
- **言語**: Swift
- **UI**: SwiftUI
- **アーキテクチャ**: Clean Architecture
- **ローカルDB**: SwiftData
- **ネットワーク**: URLSession

### Backend
- **フレームワーク**: Next.js 14+ (App Router)
- **言語**: TypeScript
- **ORM**: Prisma
- **データベース**: PostgreSQL
- **認証**: JWT (Access Token + Refresh Token)

---

## 📁 ディレクトリ構成

```
project-root/
├── ios/                         # iOSアプリ（Clean Architecture）
├── backend/                     # Next.jsバックエンド
├── docs/                        # ドキュメント
│   ├── requirements/            # 要件定義（ビジネス要件のみ）
│   ├── design/                  # 技術設計
│   │   ├── database/            # DB設計
│   │   ├── api/                 # API設計
│   │   ├── architecture/        # アーキテクチャ
│   │   └── ui-ux/               # UI/UX設計
│   └── project-management/      # プロジェクト管理
├── .claude/                     # Claude Code設定
│   ├── CLAUDE.md                # プロジェクト設定
│   ├── settings.local.json      # Hook設定
│   └── hooks/                   # 自動チェックスクリプト
├── scripts/                     # 🚀 NEW! 自動化スクリプト
│   ├── setup-dev-env.sh         # 開発環境セットアップ
│   ├── generate-feature.sh      # 機能自動生成
│   └── validate-project.sh      # プロジェクト検証
├── templates/                   # 🚀 NEW! コードテンプレート
│   ├── api-route.template.ts    # API Routeテンプレート
│   ├── swift-view.template.swift      # SwiftUI Viewテンプレート
│   └── swift-viewmodel.template.swift # ViewModelテンプレート
└── .github/workflows/           # 🚀 NEW! CI/CD設定
    ├── backend-ci.yml           # Backendビルド・テスト
    ├── ios-ci.yml               # iOSビルド・テスト
    └── docs-check.yml           # ドキュメント整合性チェック
```

---

## 🚀 使い方

### クイックスタート

```bash
# 1. テンプレートをコピー
cp -r claude-code-template-ios-backend /path/to/your-new-project
cd /path/to/your-new-project

# 2. 開発環境セットアップ（ワンコマンド）
./scripts/setup-dev-env.sh

# 3. プロジェクト設定をカスタマイズ
# .claude/CLAUDE.md を編集
# .claude/hooks/requirements-consistency-check.sh を編集

# 4. 要件定義・設計書を作成
# docs/ 配下のファイルを編集

# 5. 設計完了チェック
./scripts/validate-project.sh

# 6. 新機能を自動生成して実装開始！
./scripts/generate-feature.sh User crud
```

---

### 詳細セットアップ

#### 1. テンプレートをコピー

```bash
cp -r claude-code-template-ios-backend /path/to/your-new-project
cd /path/to/your-new-project
```

#### 2. 開発環境セットアップ

```bash
# 自動セットアップスクリプト実行
./scripts/setup-dev-env.sh
```

このスクリプトは以下を自動で実行します：
- Node.js/PostgreSQL/Xcodeのバージョンチェック
- Backend依存関係のインストール
- .envファイルの自動生成
- Prismaのセットアップ
- Claude Code hooksの実行権限付与

#### 3. プロジェクト設定をカスタマイズ

`.claude/CLAUDE.md` を編集：
- プロジェクト名
- アプリの種類
- 技術スタック

`.claude/hooks/requirements-consistency-check.sh` を編集：
```bash
FORBIDDEN_KEYWORDS=("いいね機能" "検索機能")
REQUIRED_FEATURES=("広告非表示")
REQUIRED_TABLES=("User" "Post")
```

#### 4. Phase 0: 設計フェーズ

要件定義を作成：
```bash
# テンプレートをコピーして編集
cp docs/requirements/_TEMPLATE.md docs/requirements/user-profile.md
```

技術設計を作成：
- `docs/design/database/overall-schema.md` - Prismaスキーマ
- `docs/design/api/endpoints.md` - API定義
- `docs/design/architecture/system-architecture.md` - アーキテクチャ

#### 5. 設計完了チェック

```bash
# プロジェクト検証スクリプト実行
./scripts/validate-project.sh
```

全てのチェックが通れば、Phase 1（実装）開始可能！

#### 6. Phase 1〜: 実装フェーズ

新機能を自動生成：
```bash
# CRUD機能の完全な実装
./scripts/generate-feature.sh Post crud

# APIのみ
./scripts/generate-feature.sh Comment api
```

詳細は `docs/project-management/implementation-phases.md` を参照してください。

---

## 🔍 Claude Code Hooksの機能

### 1. 要件定義整合性チェック

**トリガー**: `docs/requirements/` または `docs/design/database/` のファイル編集時

**チェック内容**:
- ✅ 実装しない機能が誤って記載されていないか
- ✅ プレミアム機能の必須特典が含まれているか
- ✅ セキュリティ・コンプライアンスの記載があるか
- ✅ データベーススキーマと要件の整合性

### 2. 型同期チェック

**トリガー**: 以下のファイル編集時
- `backend/prisma/schema.prisma`
- `backend/types/index.ts`
- `ios/[プロジェクト名]/Domain/Entities/*.swift`
- `docs/design/database/overall-schema.md`

**チェック内容**:
- ⚠️ 型定義が同期されているか警告を表示
- ⚠️ チェックリストを表示

---

## 📝 ドキュメント構成の原則

### docs/requirements/ - 要件定義
**含めるべき内容**:
- ✅ ビジネス要件
- ✅ 機能仕様
- ✅ UI/UX仕様
- ✅ バリデーションルール

**含めないべき内容**:
- ❌ データベーススキーマ
- ❌ API エンドポイント定義
- ❌ 実装コード

### docs/design/ - 技術設計
**含めるべき内容**:
- ✅ データベーススキーマ（Prisma、SwiftData）
- ✅ API エンドポイント定義
- ✅ アーキテクチャ図
- ✅ ディレクトリ構成

---

## 🎯 型変更時のチェックリスト

データベーススキーマやモデルの型を変更する際は、**必ず以下の全ての箇所を同期する**:

1. **Backend**:
   - [ ] `backend/prisma/schema.prisma`
   - [ ] `backend/types/index.ts`
   - [ ] `prisma db push` または `prisma migrate dev` 実行

2. **iOS**:
   - [ ] `ios/[プロジェクト名]/Domain/Entities/*.swift`

3. **ドキュメント**:
   - [ ] `docs/design/database/overall-schema.md`

---

## 🛠️ コーディング規約

### Swift (iOS)
- インデント: 2スペース
- 命名: camelCase (変数・関数), PascalCase (クラス・構造体)
- `any`型禁止
- ファイル名: PascalCase.swift

### TypeScript (Backend)
- インデント: 2スペース
- 命名: camelCase (変数・関数), PascalCase (クラス・型)
- `any`型禁止
- ファイル名: kebab-case.ts
- セミコロン必須

### Git
- コミットメッセージは日本語で記述

詳細は `docs/project-management/coding-standards.md` を参照してください。

---

## 📦 テンプレートに含まれるファイル

### .claude/ - Claude Code設定
- `CLAUDE.md` - プロジェクト設定（カスタマイズ必須）
- `settings.local.json` - Hook設定
- `hooks/requirements-consistency-check.sh` - 要件定義整合性チェック（カスタマイズ必須）
- `hooks/type-sync-check.sh` - 型同期チェック
- `hooks/README.md` - Hook説明書

### docs/ - ドキュメント
#### requirements/
- `_TEMPLATE.md` - 要件定義テンプレート

#### design/
- `database/overall-schema.md` - データベース設計テンプレート
- `api/endpoints.md` - REST API設計テンプレート
- `api/websocket.md` - WebSocket API設計テンプレート
- `architecture/system-architecture.md` - アーキテクチャ設計
- `architecture/directory-structure.md` - ディレクトリ構成
- `ui-ux/screen-list.md` - 画面一覧
- `ui-ux/screen-details.md` - 画面詳細設計
- `notification/notification-timing.md` - 通知タイミング設計

#### project-management/
- `implementation-phases.md` - 実装フェーズ計画
- `coding-standards.md` - コーディング規約

### scripts/ - 🚀 自動化スクリプト
- `setup-dev-env.sh` - 開発環境ワンコマンドセットアップ
- `generate-feature.sh` - 機能自動生成（CRUD/API/iOS/Docs）
- `validate-project.sh` - プロジェクト検証（Phase 0完了チェック）
- `README.md` - スクリプト使用方法

### templates/ - 🚀 コードテンプレート
- `api-route.template.ts` - Next.js API Route（GET/POST, バリデーション）
- `swift-view.template.swift` - SwiftUI View（Loading/Error/Empty状態）
- `swift-viewmodel.template.swift` - ViewModel（MVVM, Combine）
- `README.md` - テンプレート使用方法

### .github/workflows/ - 🚀 CI/CD
- `backend-ci.yml` - Backendビルド・テスト・セキュリティスキャン
- `ios-ci.yml` - iOSビルド・テスト
- `docs-check.yml` - ドキュメント整合性チェック

---

## ⚠️ 注意事項

### プロジェクト開始時に必ずやること

1. **開発環境セットアップスクリプト実行**
   ```bash
   ./scripts/setup-dev-env.sh
   ```
   このスクリプトが自動で実行権限付与、依存関係インストール、.env生成を行います。

2. **`.claude/CLAUDE.md` をカスタマイズ**
   - プロジェクト名、概要、技術スタックを記入

3. **`.claude/hooks/requirements-consistency-check.sh` をカスタマイズ**
   - `FORBIDDEN_KEYWORDS`: 実装しない機能を追加
   - `REQUIRED_FEATURES`: プレミアム必須特典を追加
   - `REQUIRED_TABLES`: データベース必須テーブルを追加

4. **Phase 0完了後の検証**
   ```bash
   ./scripts/validate-project.sh
   ```

---

## 🔗 関連ドキュメント

### 設計・アーキテクチャ
- [システムアーキテクチャ](docs/design/architecture/system-architecture.md) - 全体構成、技術スタック、データフロー
- [ディレクトリ構成](docs/design/architecture/directory-structure.md) - iOS/Backend/docsの構成

### プロジェクト管理
- [実装フェーズ計画](docs/project-management/implementation-phases.md) - Phase 0〜6の詳細スケジュール
- [コーディング規約](docs/project-management/coding-standards.md) - Swift/TypeScript/Gitの規約

### 自動化・ツール
- [Hook説明書](.claude/hooks/README.md) - 自動整合性チェックの説明
- [スクリプト説明書](scripts/README.md) - 自動化スクリプトの使い方
- [テンプレート説明書](templates/README.md) - コードテンプレートの使い方

---

## 📄 ライセンス

このテンプレートは自由に使用・改変できます。

---

## 💡 Tips

### Claude Codeで効率的に開発するために

1. **Phase 0（設計フェーズ）を丁寧に**
   - 要件定義と技術設計を最初に完成させる
   - Claudeに実装を依頼する前に、何を作るかを明確にする

2. **Hook を信頼する**
   - 要件定義と設計書の整合性は自動チェックされる
   - 型変更時のチェックリストに従う

3. **ドキュメントを常に最新に保つ**
   - 実装とドキュメントを同時に更新する
   - ドキュメントが唯一の真実の情報源

4. **型安全性を保つ**
   - `any`型は絶対に使わない
   - 型定義は Backend, iOS, ドキュメント全てで同期

---

**作成日**: 2025-12-03
