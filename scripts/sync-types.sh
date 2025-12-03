#!/bin/bash

# 型定義同期スクリプト
# Prisma → TypeScript → Swift の型定義を同期

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔄 型定義同期開始${NC}"
echo ""

# 1. Prisma Client生成
echo -e "${BLUE}1️⃣  Prismaクライアント生成中...${NC}"
cd backend
npx prisma generate
echo -e "${GREEN}✅ Prismaクライアント生成完了${NC}"
echo ""

# 2. TypeScript型定義更新（手動確認）
echo -e "${YELLOW}2️⃣  TypeScript型定義の確認${NC}"
echo -e "${YELLOW}   backend/types/index.ts を確認してください${NC}"
echo -e "${YELLOW}   Prismaスキーマと同期していることを確認してください${NC}"
echo ""

# 3. Swift型定義更新（手動確認）
echo -e "${YELLOW}3️⃣  Swift型定義の確認${NC}"
echo -e "${YELLOW}   ios/App/Domain/Entities/ のSwiftモデルを確認してください${NC}"
echo -e "${YELLOW}   Prismaスキーマと同期していることを確認してください${NC}"
echo ""

# 4. ドキュメント更新（手動確認）
echo -e "${YELLOW}4️⃣  ドキュメントの確認${NC}"
echo -e "${YELLOW}   docs/design/database/overall-schema.md を確認してください${NC}"
echo ""

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}✅ Prisma Client生成完了${NC}"
echo ""
echo -e "${YELLOW}次のステップ:${NC}"
echo "1. backend/types/index.ts を更新"
echo "2. ios/App/Domain/Entities/*.swift を更新"
echo "3. docs/design/database/overall-schema.md を更新"
echo "4. 型同期チェックhookが自動実行されます"
echo ""
