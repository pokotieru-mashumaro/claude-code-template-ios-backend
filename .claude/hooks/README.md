# Claude Code Hooks

このディレクトリには、Claude Codeが自動実行するhookスクリプトが含まれています。

---

## 設定済みHooks

### 1. requirements-consistency-check.sh

**目的**: 要件定義ファイルの整合性を自動チェック

**トリガー**: `docs/requirements/` または `docs/design/database/` 配下の `.md` ファイルを `Write` または `Edit` ツールで編集したとき

**チェック内容**:
1. **実装しない機能のチェック** ⚠️ カスタマイズ必須
   - プロジェクト固有の「実装しない機能」を定義して、誤って記載されていないか確認

2. **プレミアム機能の整合性チェック**
   - 必須特典の存在確認
   - 特典数の妥当性チェック

3. **セキュリティ・コンプライアンスのチェック**
   - security-compliance.md の存在確認
   - 必須項目の記載確認

4. **データベーススキーマとの整合性チェック**
   - 必須テーブルの存在確認

5. **API設計との整合性チェック**
   - APIエンドポイント定義の存在確認

**カスタマイズ方法**:
`.claude/hooks/requirements-consistency-check.sh` を開いて、以下のセクションを編集してください：
- `FORBIDDEN_KEYWORDS`: 実装しない機能のキーワード
- `REQUIRED_FEATURES`: プレミアム機能の必須特典
- `REQUIRED_TABLES`: データベース必須テーブル

**実行結果**:
- ✅ エラーなし: exit code 0
- ⚠️  警告のみ: exit code 0（警告メッセージ表示）
- ❌ エラーあり: exit code 1（エラーメッセージ表示、修正が必要）

---

### 2. type-sync-check.sh

**目的**: データベーススキーマ、型定義、iOSモデル、設計書の同期チェック

**トリガー**: 以下のファイルを `Write` または `Edit` ツールで編集したとき
- `backend/prisma/schema.prisma`
- `backend/types/index.ts`
- `ios/[プロジェクト名]/Domain/Entities/*.swift`
- `docs/design/database/overall-schema.md`

**チェック内容**:
1. **Prismaスキーマ変更時**
   - backend/types/index.ts が同期されているか確認
   - iOS Entitiesが同期されているか確認
   - ドキュメントが更新されているか確認

2. **Backend型定義変更時**
   - Prismaスキーマと一致しているか確認
   - iOS Entitiesと一致しているか確認

3. **iOSモデル変更時**
   - Backend型定義と一致しているか確認
   - Prismaスキーマと一致しているか確認

4. **設計書更新時**
   - Prismaスキーマと一致しているか確認

**同期すべき箇所**:
- ✅ backend/prisma/schema.prisma
- ✅ backend/types/index.ts
- ✅ ios/[プロジェクト名]/Domain/Entities/*.swift
- ✅ docs/design/database/overall-schema.md
- ✅ `prisma db push` または `prisma migrate dev` 実行

**実行結果**:
- ⚠️  警告のみ: exit code 0（チェックリスト表示）
- 同期の確認と修正は手動で行う

---

## Hookの設定

`.claude/settings.local.json` で以下のように設定されています：

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "if [[ \"$TOOL_INPUT_FILE_PATH\" =~ ^docs/requirements/.*\\.md$ ]] || [[ \"$TOOL_INPUT_FILE_PATH\" =~ ^docs/design/database/.*\\.md$ ]]; then .claude/hooks/requirements-consistency-check.sh; fi"
          },
          {
            "type": "command",
            "command": "if [[ \"$TOOL_INPUT_FILE_PATH\" =~ schema\\.prisma$ ]] || [[ \"$TOOL_INPUT_FILE_PATH\" =~ types/index\\.ts$ ]] || [[ \"$TOOL_INPUT_FILE_PATH\" =~ /Entities/.*\\.swift$ ]] || [[ \"$TOOL_INPUT_FILE_PATH\" =~ overall-schema\\.md$ ]]; then CHANGED_FILES=\"$TOOL_INPUT_FILE_PATH\" .claude/hooks/type-sync-check.sh; fi"
          }
        ]
      },
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "if [[ \"$TOOL_INPUT_FILE_PATH\" =~ ^docs/requirements/.*\\.md$ ]] || [[ \"$TOOL_INPUT_FILE_PATH\" =~ ^docs/design/database/.*\\.md$ ]]; then .claude/hooks/requirements-consistency-check.sh; fi"
          },
          {
            "type": "command",
            "command": "if [[ \"$TOOL_INPUT_FILE_PATH\" =~ schema\\.prisma$ ]] || [[ \"$TOOL_INPUT_FILE_PATH\" =~ types/index\\.ts$ ]] || [[ \"$TOOL_INPUT_FILE_PATH\" =~ /Entities/.*\\.swift$ ]] || [[ \"$TOOL_INPUT_FILE_PATH\" =~ overall-schema\\.md$ ]]; then CHANGED_FILES=\"$TOOL_INPUT_FILE_PATH\" .claude/hooks/type-sync-check.sh; fi"
          }
        ]
      }
    ]
  }
}
```

---

## 手動実行

hookは自動実行されますが、手動でも実行可能です：

```bash
# 要件定義整合性チェック
.claude/hooks/requirements-consistency-check.sh

# 型同期チェック（環境変数で変更ファイルを指定）
CHANGED_FILES="backend/prisma/schema.prisma" .claude/hooks/type-sync-check.sh
```

---

## Hookの無効化

一時的にhookを無効にする場合、`.claude/settings.local.json` に追加：

```json
{
  "disableAllHooks": true
}
```

---

## トラブルシューティング

### Hookが実行されない

1. スクリプトに実行権限があるか確認：
   ```bash
   chmod +x .claude/hooks/*.sh
   ```

2. `.claude/settings.local.json` の設定を確認

3. `disableAllHooks` が `true` になっていないか確認

### エラーが出る

エラーメッセージに従って、該当するファイルを修正してください。

整合性チェックは**requirements/を唯一の真実**として、他のドキュメントとの矛盾を検出します。

---

## カスタマイズガイド

### プロジェクト開始時に必ずやること

1. **requirements-consistency-check.sh のカスタマイズ**
   - `FORBIDDEN_KEYWORDS`: 実装しない機能を追加
   - `REQUIRED_FEATURES`: プレミアム必須特典を追加
   - `REQUIRED_TABLES`: データベース必須テーブルを追加

2. **実行権限の付与**
   ```bash
   chmod +x .claude/hooks/*.sh
   ```

3. **動作確認**
   ```bash
   .claude/hooks/requirements-consistency-check.sh
   .claude/hooks/type-sync-check.sh
   ```

---

**最終更新日**: 2025-12-03
