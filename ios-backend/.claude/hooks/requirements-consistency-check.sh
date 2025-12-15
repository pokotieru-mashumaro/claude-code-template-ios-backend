#!/bin/bash

# 要件定義ファイルの整合性チェックhook（汎用版）
# docs/requirements/ 配下のファイルが編集されたときに実行される

set -e

# 色定義
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "🔍 要件定義の整合性チェックを開始..."

# チェック対象ディレクトリ
REQUIREMENTS_DIR="docs/requirements"
DESIGN_DIR="docs/design"

# エラーカウンター
ERROR_COUNT=0
WARNING_COUNT=0

# プロジェクト固有の禁止機能チェック（カスタマイズ必須）
check_forbidden_features() {
    echo ""
    echo "📋 実装しない機能のチェック..."

    # このセクションはプロジェクトごとにカスタマイズしてください
    # 例: 実装しない機能のキーワードを追加
    FORBIDDEN_KEYWORDS=(
        # "いいね機能"
        # "検索機能"
    )

    for keyword in "${FORBIDDEN_KEYWORDS[@]}"; do
        if grep -r "$keyword" "$REQUIREMENTS_DIR" > /dev/null 2>&1; then
            echo -e "${RED}❌ エラー: 実装しない機能「$keyword」が requirements/ に含まれています${NC}"
            grep -rn "$keyword" "$REQUIREMENTS_DIR" | head -3
            ((ERROR_COUNT++))
        fi
    done

    if [ ${#FORBIDDEN_KEYWORDS[@]} -eq 0 ]; then
        echo -e "${YELLOW}⚠️  このチェックはカスタマイズが必要です${NC}"
        echo -e "${YELLOW}   .claude/hooks/requirements-consistency-check.sh を編集してください${NC}"
    fi
}

# プレミアム機能の整合性チェック（カスタマイズ推奨）
check_premium_features() {
    echo ""
    echo "📋 プレミアム機能の整合性チェック..."

    PREMIUM_FILE="$REQUIREMENTS_DIR/premium-features.md"

    if [ -f "$PREMIUM_FILE" ]; then
        # プレミアム特典の数をカウント
        FEATURE_COUNT=$(grep -c "^####" "$PREMIUM_FILE" 2>/dev/null || echo 0)

        if [ "$FEATURE_COUNT" -gt 10 ]; then
            echo -e "${YELLOW}⚠️  警告: プレミアム特典が多すぎます（$FEATURE_COUNT 個）${NC}"
            echo -e "${YELLOW}   → 6〜8個程度が推奨です${NC}"
            ((WARNING_COUNT++))
        fi

        # 必須特典の確認（プロジェクトごとにカスタマイズ）
        REQUIRED_FEATURES=(
            # "広告非表示"
        )

        for feature in "${REQUIRED_FEATURES[@]}"; do
            if ! grep -q "$feature" "$PREMIUM_FILE" 2>/dev/null; then
                echo -e "${YELLOW}⚠️  警告: 推奨されるプレミアム特典「$feature」が記載されていません${NC}"
                ((WARNING_COUNT++))
            fi
        done
    else
        echo -e "${YELLOW}⚠️  premium-features.md が見つかりません${NC}"
    fi
}

# セキュリティ・コンプライアンスチェック
check_security_compliance() {
    echo ""
    echo "📋 セキュリティ・コンプライアンスのチェック..."

    SECURITY_FILE="$REQUIREMENTS_DIR/security-compliance.md"

    if [ ! -f "$SECURITY_FILE" ]; then
        echo -e "${YELLOW}⚠️  security-compliance.md が存在しません${NC}"
        echo -e "${YELLOW}   → セキュリティ要件の明示化を推奨します${NC}"
        ((WARNING_COUNT++))
        return
    fi

    # 必須セキュリティ項目のチェック
    REQUIRED_ITEMS=(
        "パスワード"
        "暗号化"
        "認証"
    )

    for item in "${REQUIRED_ITEMS[@]}"; do
        if ! grep -q "$item" "$SECURITY_FILE" 2>/dev/null; then
            echo -e "${YELLOW}⚠️  警告: security-compliance.md に「$item」の記載がありません${NC}"
            ((WARNING_COUNT++))
        fi
    done
}

# データベーススキーマとの整合性チェック
check_db_schema_consistency() {
    echo ""
    echo "📋 データベーススキーマとの整合性チェック..."

    DB_SCHEMA="$DESIGN_DIR/database/overall-schema.md"

    if [ ! -f "$DB_SCHEMA" ]; then
        echo -e "${YELLOW}⚠️  警告: データベーススキーマファイルが見つかりません${NC}"
        echo -e "${YELLOW}   → docs/design/database/overall-schema.md を作成してください${NC}"
        ((WARNING_COUNT++))
        return
    fi

    # 必須テーブルの存在確認（プロジェクトごとにカスタマイズ）
    REQUIRED_TABLES=(
        "User"
    )

    for table in "${REQUIRED_TABLES[@]}"; do
        if ! grep -q "model $table\|$table {" "$DB_SCHEMA" 2>/dev/null; then
            echo -e "${YELLOW}⚠️  警告: 必須テーブル「$table」がDBスキーマに見つかりません${NC}"
            ((WARNING_COUNT++))
        fi
    done
}

# API設計との整合性チェック
check_api_consistency() {
    echo ""
    echo "📋 API設計との整合性チェック..."

    API_FILE="$DESIGN_DIR/api/endpoints.md"

    if [ ! -f "$API_FILE" ]; then
        echo -e "${YELLOW}⚠️  警告: APIエンドポイント定義ファイルが見つかりません${NC}"
        echo -e "${YELLOW}   → docs/design/api/endpoints.md を作成してください${NC}"
        ((WARNING_COUNT++))
    fi
}

# メイン処理
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
check_forbidden_features
check_premium_features
check_security_compliance
check_db_schema_consistency
check_api_consistency
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 結果サマリー
echo ""
if [ $ERROR_COUNT -eq 0 ] && [ $WARNING_COUNT -eq 0 ]; then
    echo -e "${GREEN}✅ 整合性チェック完了: エラーなし${NC}"
    exit 0
elif [ $ERROR_COUNT -eq 0 ]; then
    echo -e "${YELLOW}⚠️  整合性チェック完了: ${WARNING_COUNT}件の警告${NC}"
    exit 0
else
    echo -e "${RED}❌ 整合性チェック失敗: ${ERROR_COUNT}件のエラー, ${WARNING_COUNT}件の警告${NC}"
    echo ""
    echo -e "${YELLOW}修正が必要です。requirements/ 配下のファイルを見直してください。${NC}"
    exit 1
fi
