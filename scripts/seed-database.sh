#!/bin/bash

# データベースシード投入スクリプト
# 使用方法: ./scripts/seed-database.sh

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🌱 データベースシード投入開始${NC}"
echo ""

# backendディレクトリの確認
if [ ! -d "backend" ]; then
  echo -e "${YELLOW}⚠️  backendディレクトリが見つかりません${NC}"
  exit 1
fi

cd backend

# .envファイルの確認
if [ ! -f ".env" ]; then
  echo -e "${YELLOW}⚠️  .envファイルが見つかりません${NC}"
  echo -e "${YELLOW}   backend/.envを作成してください${NC}"
  exit 1
fi

# Prismaクライアント生成
echo -e "${BLUE}📦 Prismaクライアント生成中...${NC}"
npx prisma generate

# シード実行
echo -e "${BLUE}🌱 シードデータ投入中...${NC}"
npm run prisma:seed

echo ""
echo -e "${GREEN}✅ シードデータ投入完了！${NC}"
