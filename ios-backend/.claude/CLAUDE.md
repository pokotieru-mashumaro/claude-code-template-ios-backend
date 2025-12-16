# Claude Code プロジェクト設定

このファイルは **[プロジェクト名]** 専用のClaude Code設定です。

---

## プロジェクト概要

**プロジェクト名**: [プロジェクト名を記入]
**種別**: [アプリの種類を記入 例: マッチングアプリ、ECサイト、SNS等]
**フロントエンド**: iOS (SwiftUI)
**バックエンド**: Next.js (TypeScript) + Supabase（オプショナル）
**BaaS**: Supabase (PostgreSQL, Auth, Storage, Realtime)
**その他**: [追加の技術スタックがあれば記入 例: Python FastAPI]

---

## アーキテクチャ方針

このプロジェクトは**ハイブリッドアーキテクチャ**を採用しています。

### iOSアプリのデータアクセス方法

#### 1. 直接Supabaseにアクセス（シンプルなCRUD）
```
iOS App → Supabase
```
- 適用: ユーザープロフィール取得・更新、投稿CRUD、リアルタイム機能
- メリット: 低レイテンシ、低コスト、シンプル

#### 2. Next.js Backend経由でアクセス（複雑な処理）
```
iOS App → Next.js Backend → Supabase
```
- 適用: 外部API連携（Stripe、OpenAI等）、管理者機能、複雑なビジネスロジック
- メリット: セキュア、ロジック集約、RLSバイパス可能

#### 3. ハイブリッド（推奨✨）
```
iOS App
  ├─ 単純なCRUD → 直接Supabase
  └─ 複雑な処理 → Next.js Backend → Supabase
```

**実装例**:
- ユーザープロフィール取得: iOS → Supabase（直接）
- 課金処理: iOS → Next.js → Stripe + Supabase
- AIレコメンデーション: iOS → Next.js → OpenAI + Supabase

### Backendが不要な場合
シンプルなCRUDアプリの場合、`backend/`ディレクトリを削除してSupabase RLSでセキュリティを確保できます。

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
- `security-compliance.md`: セキュリティ・コンプライアンス
- `legal-compliance.md`: 法的コンプライアンス（必要に応じて）

### docs/design/ - 技術設計
システム全体の技術的な設計を記載。

#### docs/design/database/
- `overall-schema.md`: データベース全体設計（Prismaスキーマ、ER図）

#### docs/design/api/
- `endpoints.md`: REST APIエンドポイント一覧
- `websocket.md`: WebSocket API仕様（リアルタイム通信が必要な場合）

#### docs/design/architecture/
- `system-architecture.md`: システムアーキテクチャ全体像
- `directory-structure.md`: ディレクトリ構成

#### docs/design/ui-ux/
- `screen-list.md`: 画面一覧
- `screen-details.md`: 画面詳細設計

#### docs/design/notification/
- `notification-timing.md`: 通知タイミング設計（通知機能がある場合）

### docs/project-management/ - プロジェクト管理
- `implementation-phases.md`: 実装フェーズ計画
- `coding-standards.md`: コーディング規約

---

## 自動化ツール・スクリプト

### scripts/ - 自動化スクリプト

#### scripts/setup-dev-env.sh
**用途**: 開発環境のワンコマンドセットアップ

**実行内容**:
- Node.js/Supabase/Xcodeのバージョンチェック
- Backend依存関係の自動インストール
- `.env`ファイルの自動生成（Supabase設定）
- Prismaのセットアップ
- Git hooksの自動設定
- Claude Code hooksの実行権限付与

**使用方法**:
```bash
./scripts/setup-dev-env.sh
```

**推奨タイミング**: プロジェクトクローン直後

---

#### scripts/generate-feature.sh
**用途**: 新機能のボイラープレートコード自動生成

**使用方法**:
```bash
./scripts/generate-feature.sh <feature-name> <type>

# 例
./scripts/generate-feature.sh User crud    # CRUD機能の完全な実装
./scripts/generate-feature.sh Post api     # APIエンドポイントのみ
./scripts/generate-feature.sh Comment docs # ドキュメントのみ
```

**タイプ**:
- `crud`: ドキュメント + Backend API + iOS UI（予定）
- `api`: Backend APIエンドポイントのみ
- `ios`: iOS画面とViewModelのみ（予定）
- `docs`: ドキュメントのみ

**生成されるファイル**:
- `docs/requirements/{feature-kebab}.md`
- `backend/app/api/{feature-kebab}/route.ts`
- `backend/app/api/{feature-kebab}/[id]/route.ts`

**推奨タイミング**: 新機能追加時

---

#### scripts/validate-project.sh
**用途**: プロジェクト設計の完全性チェック（Phase 0完了確認）

**使用方法**:
```bash
./scripts/validate-project.sh
```

**チェック内容**:
- 必須ドキュメントの存在確認
- ドキュメント内の未記入項目チェック
- Prismaスキーマの妥当性チェック
- API設計の完全性チェック
- Claude Code設定の確認
- `.gitignore`の確認
- 実装フェーズの進捗確認

**推奨タイミング**: Phase 0（設計フェーズ）完了時、Phase 1開始前

---

### templates/ - コードテンプレート

#### templates/api-route.template.ts
Next.js API Routeのテンプレート
- GET（一覧取得、ページネーション対応）
- POST（作成、Zodバリデーション）
- エラーハンドリング、レスポンスフォーマット統一

#### templates/swift-view.template.swift
SwiftUI Viewのテンプレート
- Loading/Error/Empty状態の表示
- List表示、Pull to Refresh
- NavigationView

#### templates/swift-viewmodel.template.swift
ViewModelのテンプレート（MVVM）
- State管理（idle, loading, loaded, error）
- Repository連携、Combine対応

**使用方法**: `generate-feature.sh`が自動的に使用

---

### .github/workflows/ - CI/CD

#### .github/workflows/backend-ci.yml
Backend用のGitHub Actions
- TypeScript型チェック
- ESLint
- Prismaマイグレーション
- テスト実行
- npm audit（セキュリティスキャン）
- TruffleHog（シークレット検出）

#### .github/workflows/ios-ci.yml
iOS用のGitHub Actions
- Xcodeビルド
- テスト実行
- SwiftLint

#### .github/workflows/docs-check.yml
ドキュメント用のGitHub Actions
- 要件定義整合性チェック
- ドキュメント完全性チェック
- TODO/未記入項目検出

---

## ファイル編集時のルール

### 要件定義ファイル (docs/requirements/)
**含めるべき内容**:
- ✅ ビジネス要件
- ✅ 機能仕様
- ✅ UI/UX仕様
- ✅ バリデーションルール
- ✅ エラーハンドリング

**含めないべき内容**:
- ❌ データベーススキーマ
- ❌ API エンドポイント定義
- ❌ 実装コード
- ❌ アーキテクチャ詳細

### 技術設計ファイル (docs/design/)
**含めるべき内容**:
- ✅ データベーススキーマ（Prisma、SwiftData）
- ✅ API エンドポイント定義
- ✅ アーキテクチャ図
- ✅ ディレクトリ構成
- ✅ 技術スタック

---

## コーディング規約

### Swift (iOS)
- インデント: 2スペース
- 命名: camelCase (変数・関数), PascalCase (クラス・構造体)
- `any`型禁止
- ファイル名: PascalCase.swift
- **UI実装時は必ず `ios-design` skillを使用すること**
  ```bash
  /ios-design
  ```

### TypeScript (Backend)
- インデント: 2スペース
- 命名: camelCase (変数・関数), PascalCase (クラス・型)
- `any`型禁止 (unknownまたは具体的な型を使用)
- ファイル名: kebab-case.ts
- セミコロン必須

### Python (必要な場合)
- インデント: 4スペース (PEP 8)
- 命名: snake_case (変数・関数), PascalCase (クラス)
- 型ヒント必須
- ファイル名: snake_case.py

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

**例**:
```
feat: ユーザー登録機能の基本実装を追加

- ユーザー登録フォームの実装
- バリデーション処理
- メール確認機能
```

**必須**: コミットメッセージは日本語で記述

---

## 実装フェーズ

現在: **Phase 0 - 設計フェーズ**

詳細は `docs/project-management/implementation-phases.md` を参照してください。

基本的なフェーズ例:
- Phase 0: 設計フェーズ（要件定義、DB設計、API設計）
- Phase 1: バックエンド基盤構築（Next.js、Supabase、認証）
- Phase 2: iOS基盤構築（Clean Architecture、ネットワーク層）
- Phase 3: コア機能実装
- Phase 4: 追加機能実装
- Phase 5: テスト・デバッグ
- Phase 6: リリース準備

---

## 重要な設計原則

### 1. 要件と実装の分離
- 要件定義に技術的詳細を含めない
- 技術設計は別ファイルに記載

### 2. 機能単位でのドキュメント管理
- 各機能ごとに要件定義を作成
- 全体設計は別途まとめる

### 3. Clean Architecture
- iOS: Presentation → Domain → Data
- Backend: API Routes → Business Logic → Data Access

### 4. データ整合性
- バックエンドが唯一の真実の情報源
- iOSはキャッシュとして使用

### 5. 型変更時の影響範囲チェック（重要）
データベーススキーマやモデルの型を変更する際は、**必ず以下の全ての箇所を同期する**:

#### モデルのフィールド追加・変更時:
1. **Backend**:
   - `backend/prisma/schema.prisma` - Prismaスキーマ
   - `backend/types/index.ts` - TypeScript型定義
   - `prisma db push` または `prisma migrate dev` 実行

2. **iOS**:
   - `ios/[プロジェクト名]/Domain/Entities/` - Swiftモデル定義

3. **ドキュメント**:
   - `docs/design/database/overall-schema.md` - データベース設計書

**チェックリスト例（新しいフィールド追加の場合）**:
- [ ] Prismaスキーマに追加
- [ ] `prisma db push`実行
- [ ] backend/types/index.tsに追加
- [ ] iOS対応モデルに追加
- [ ] docs/design/database/overall-schema.mdに追加

---

## 注意事項

### セキュリティ
- `any`型は絶対に使用禁止
- 認証はSupabase Authを使用（自動でJWT管理）
- Row Level Security (RLS)を必ず有効化
- Service Role Keyは環境変数で管理、公開禁止
- HTTPS/WSS必須

### パフォーマンス
- N+1問題の回避
- 適切なインデックス設定
- ページネーション実装
- 画像はCDN配信

### テスト
- ユニットテストカバレッジ70%以上
- 重要な機能はE2Eテスト

---

## よくある質問

### Q: 新しい機能を追加する時はどこに書くべき？
A: まず `docs/requirements/` に新規要件定義ファイルを作成。その後、必要に応じて `docs/design/` 配下のDB/API設計を更新。

### Q: データベーススキーマを変更したい
A: `docs/design/database/overall-schema.md` を更新し、Prismaスキーマを修正。マイグレーションを実行。

### Q: 新しいAPIエンドポイントを追加したい
A: `docs/design/api/endpoints.md` または `websocket.md` に定義を追加してから実装。または `./scripts/generate-feature.sh [機能名] api` で自動生成。

### Q: 新機能を素早く追加したい
A: `./scripts/generate-feature.sh [機能名] crud` でボイラープレートを自動生成。生成後、必要に応じてカスタマイズ。

### Q: Phase 0が完了したか確認したい
A: `./scripts/validate-project.sh` を実行。全てのチェックが通れば実装開始可能。

---

## プロジェクト開始チェックリスト

新しいプロジェクトでこのテンプレートを使用する際の手順:

1. **テンプレートをコピー**
   ```bash
   cp -r claude-code-template-ios-backend /path/to/new-project
   cd /path/to/new-project
   ```

2. **開発環境セットアップ**
   ```bash
   ./scripts/setup-dev-env.sh
   ```

3. **プロジェクト情報をカスタマイズ**
   - [ ] `.claude/CLAUDE.md`のプロジェクト名、種別を記入
   - [ ] `.claude/hooks/requirements-consistency-check.sh`をカスタマイズ
     - `FORBIDDEN_KEYWORDS`: 実装しない機能を追加
     - `REQUIRED_FEATURES`: プレミアム必須特典を追加
     - `REQUIRED_TABLES`: データベース必須テーブルを追加
   - [ ] `.claude/skills/ios-design/SKILL.md`を確認
     - iOS UIデザインのガイドライン
     - SwiftUIのベストプラクティス

4. **Phase 0: 設計フェーズ**
   - [ ] 要件定義を作成（`docs/requirements/`）
   - [ ] データベース設計（`docs/design/database/overall-schema.md`）
   - [ ] API設計（`docs/design/api/endpoints.md`）
   - [ ] アーキテクチャ設計（`docs/design/architecture/`）

5. **設計完了チェック**
   ```bash
   ./scripts/validate-project.sh
   ```

6. **Phase 1〜: 実装開始**
   - 新機能は `./scripts/generate-feature.sh [機能名] crud` で自動生成
   - 詳細は `docs/project-management/implementation-phases.md` 参照

---

## Git Worktreeを使った機能開発

機能追加や修正を行う際は、**git worktree**を使用してブランチごとに独立した作業ディレクトリで開発します。

### Pluginの使用（必須）

**`~/.claude`にインストールされているpluginを使用してください。**

特に以下のコマンドが利用可能です：

#### Git Flow関連（git-workflow plugin）
```bash
# 新機能ブランチを作成
/git-workflow:feature <feature-name>

# リリースブランチを作成
/git-workflow:release <version>

# ホットフィックスブランチを作成
/git-workflow:hotfix <hotfix-name>

# ブランチを完了・マージ
/git-workflow:finish [--no-delete] [--no-tag]

# Git Flowステータス確認
/git-workflow:flow-status
```

#### コミット・PR関連（commit-commands plugin）
```bash
# コミット作成
/commit-commands:commit

# コミット、プッシュ、PR作成を一括実行
/commit-commands:commit-push-pr

# 削除済みリモートブランチのローカルクリーンアップ
/commit-commands:clean_gone
```

#### コードレビュー関連（pr-review-toolkit plugin）
```bash
# PRの包括的レビュー
/pr-review-toolkit:review-pr [review-aspects]
```

### 機能開発ワークフロー

1. **機能ブランチ作成**
   ```bash
   /git-workflow:feature user-authentication
   ```

2. **実装作業**
   - コードを実装
   - テストを作成・実行

3. **コミット**
   ```bash
   /commit-commands:commit
   ```

4. **レビュー・PR作成**
   ```bash
   /pr-review-toolkit:review-pr
   /commit-commands:commit-push-pr
   ```

5. **機能完了**
   ```bash
   /git-workflow:finish
   ```

### 注意事項

- 機能開発は必ずfeatureブランチで行う
- mainブランチへの直接コミットは禁止
- PRを作成する前に必ずレビューpluginを実行する

---

**最終更新日**: 2025-12-16
