#!/bin/bash

# ============================================
# プロジェクト設計バリデーションスクリプト
# ============================================

set -e

echo "======================================"
echo "プロジェクト設計バリデーション"
echo "======================================"

# 色の定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# カウンター
ERRORS=0
WARNINGS=0

# チェック関数
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        return 0
    else
        echo -e "${RED}✗${NC} $1 が見つかりません"
        ((ERRORS++))
        return 1
    fi
}

check_placeholder() {
    if grep -q "\[.*\]" "$1" 2>/dev/null; then
        echo -e "${YELLOW}!${NC} $1 に未記入項目があります"
        ((WARNINGS++))
        return 1
    fi
    return 0
}

echo ""
echo "1. 必須ドキュメントのチェック..."
echo "------------------------------"

check_file ".claude/CLAUDE.md"
check_file "docs/requirements/_TEMPLATE.md"
check_file "docs/design/database/overall-schema.md"
check_file "docs/design/api/endpoints.md"
check_file "docs/design/architecture/system-architecture.md"
check_file "docs/project-management/implementation-phases.md"

echo ""
echo "2. Prismaスキーマのチェック..."
echo "------------------------------"

check_file "prisma/schema.prisma"

if [ -f "prisma/schema.prisma" ]; then
    if npx prisma validate 2>/dev/null; then
        echo -e "${GREEN}✓${NC} Prismaスキーマは有効です"
    else
        echo -e "${RED}✗${NC} Prismaスキーマにエラーがあります"
        ((ERRORS++))
    fi
fi

echo ""
echo "3. 環境設定のチェック..."
echo "------------------------------"

check_file ".env.example"
check_file ".gitignore"
check_file "package.json"
check_file "tsconfig.json"

echo ""
echo "4. 未記入項目のチェック..."
echo "------------------------------"

check_placeholder ".claude/CLAUDE.md"
check_placeholder "docs/design/database/overall-schema.md"

echo ""
echo "======================================"
echo "結果サマリー"
echo "======================================"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}全てのチェックに合格しました！${NC}"
    echo "実装を開始できます。"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}警告: $WARNINGS 件${NC}"
    echo "未記入項目を確認してください。"
    exit 0
else
    echo -e "${RED}エラー: $ERRORS 件${NC}"
    echo -e "${YELLOW}警告: $WARNINGS 件${NC}"
    echo "エラーを修正してください。"
    exit 1
fi
