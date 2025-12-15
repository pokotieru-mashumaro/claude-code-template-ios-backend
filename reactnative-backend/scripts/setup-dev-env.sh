#!/bin/bash

# ============================================
# React Native + Backend 開発環境セットアップスクリプト
# ============================================

set -e

echo "======================================"
echo "React Native + Backend 開発環境セットアップ"
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
check_command npx

echo ""
echo "2. Backend 依存関係のインストール..."
echo "------------------------------"

cd backend
npm install
cd ..
echo -e "${GREEN}✓${NC} Backend 依存関係をインストールしました"

echo ""
echo "3. Mobile 依存関係のインストール..."
echo "------------------------------"

cd mobile
npm install
cd ..
echo -e "${GREEN}✓${NC} Mobile 依存関係をインストールしました"

echo ""
echo "4. 環境変数ファイルの作成..."
echo "------------------------------"

if [ ! -f backend/.env.local ]; then
    cp backend/.env.example backend/.env.local
    echo -e "${GREEN}✓${NC} backend/.env.local を作成しました"
else
    echo -e "${YELLOW}!${NC} backend/.env.local は既に存在します"
fi

if [ ! -f mobile/.env ]; then
    cp mobile/.env.example mobile/.env
    echo -e "${GREEN}✓${NC} mobile/.env を作成しました"
else
    echo -e "${YELLOW}!${NC} mobile/.env は既に存在します"
fi

echo -e "${YELLOW}!${NC} 各 .env ファイルを編集してSupabaseの設定を入力してください"

echo ""
echo "5. Prismaのセットアップ..."
echo "------------------------------"

cd backend
npx prisma generate
cd ..
echo -e "${GREEN}✓${NC} Prisma クライアントを生成しました"

echo ""
echo "6. Claude Code Hooksの権限設定..."
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
echo "1. backend/.env.local と mobile/.env を編集してSupabaseの設定を入力"
echo "2. Backend: cd backend && npm run dev"
echo "3. Mobile: cd mobile && npm start"
echo ""
