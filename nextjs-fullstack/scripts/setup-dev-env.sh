#!/bin/bash

# ============================================
# Next.js Fullstack 開発環境セットアップスクリプト
# ============================================

set -e

echo "======================================"
echo "Next.js Fullstack 開発環境セットアップ"
echo "======================================"

# 色の定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# チェック関数
check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 がインストールされています"
        return 0
    else
        echo -e "${RED}✗${NC} $1 がインストールされていません"
        return 1
    fi
}

# Node.jsバージョンチェック
check_node_version() {
    local required_version=18
    local current_version=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)

    if [ "$current_version" -ge "$required_version" ]; then
        echo -e "${GREEN}✓${NC} Node.js v$current_version (必要: v$required_version以上)"
        return 0
    else
        echo -e "${RED}✗${NC} Node.js v$current_version (必要: v$required_version以上)"
        return 1
    fi
}

echo ""
echo "1. 必要なツールのチェック..."
echo "------------------------------"

check_command node
check_node_version
check_command npm

echo ""
echo "2. 依存関係のインストール..."
echo "------------------------------"

npm install

echo ""
echo "3. 環境変数ファイルの作成..."
echo "------------------------------"

if [ ! -f .env.local ]; then
    cp .env.example .env.local
    echo -e "${GREEN}✓${NC} .env.local を作成しました"
    echo -e "${YELLOW}!${NC} .env.local を編集してSupabaseの設定を入力してください"
else
    echo -e "${YELLOW}!${NC} .env.local は既に存在します"
fi

echo ""
echo "4. Prismaのセットアップ..."
echo "------------------------------"

npx prisma generate
echo -e "${GREEN}✓${NC} Prisma クライアントを生成しました"

echo ""
echo "5. Claude Code Hooksの権限設定..."
echo "------------------------------"

if [ -d ".claude/hooks" ]; then
    chmod +x .claude/hooks/*.sh 2>/dev/null || true
    echo -e "${GREEN}✓${NC} Hooks に実行権限を付与しました"
fi

echo ""
echo "======================================"
echo -e "${GREEN}セットアップ完了！${NC}"
echo "======================================"
echo ""
echo "次のステップ:"
echo "1. .env.local を編集してSupabaseの設定を入力"
echo "2. npm run dev で開発サーバーを起動"
echo ""
