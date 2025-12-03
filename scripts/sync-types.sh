#!/bin/bash

# 型定義同期スクリプト
# Prisma → TypeScript → Swift の型定義を同期（Supabase対応）

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔄 型定義同期開始（Supabase対応）${NC}"
echo ""

# 1. Prisma Client生成
echo -e "${BLUE}1️⃣  Prismaクライアント生成中...${NC}"
cd backend
npx prisma generate
echo -e "${GREEN}✅ Prismaクライアント生成完了${NC}"
echo ""

# 2. Supabase型定義生成（オプション）
echo -e "${BLUE}2️⃣  Supabase型定義生成（オプション）${NC}"
if command -v supabase &> /dev/null; then
  echo -e "${YELLOW}   Supabase CLIが利用可能です${NC}"
  echo -e "${YELLOW}   型定義を自動生成する場合: supabase gen types typescript --local > types/supabase.ts${NC}"
else
  echo -e "${YELLOW}   Supabase CLIがインストールされていません${NC}"
  echo -e "${YELLOW}   インストール: https://supabase.com/docs/guides/cli${NC}"
fi
echo ""

# 3. TypeScript型定義更新（手動確認）
echo -e "${YELLOW}3️⃣  TypeScript型定義の確認${NC}"
echo -e "${YELLOW}   backend/types/index.ts を確認してください${NC}"
echo -e "${YELLOW}   Prismaスキーマと同期していることを確認してください${NC}"
echo -e "${YELLOW}   ⚠️  注意: Supabaseは snake_case、TypeScriptは camelCase${NC}"
echo ""

# 4. Swift型定義更新（手動確認）
echo -e "${YELLOW}4️⃣  Swift型定義の確認${NC}"
echo -e "${YELLOW}   ios/App/Domain/Entities/ のSwiftモデルを確認してください${NC}"
echo -e "${YELLOW}   Prismaスキーマと同期していることを確認してください${NC}"
echo -e "${YELLOW}   ⚠️  注意: Supabase UUIDは Swift の String として定義${NC}"
echo ""

# 5. RLSポリシー更新（手動確認）
echo -e "${YELLOW}5️⃣  Supabase RLSポリシーの確認${NC}"
echo -e "${YELLOW}   backend/prisma/rls-policies.sql を確認してください${NC}"
echo -e "${YELLOW}   新しいテーブルにRLSポリシーを追加してください${NC}"
echo ""

# 6. ドキュメント更新（手動確認）
echo -e "${YELLOW}6️⃣  ドキュメントの確認${NC}"
echo -e "${YELLOW}   docs/design/database/overall-schema.md を確認してください${NC}"
echo ""

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}✅ Prisma Client生成完了${NC}"
echo ""
echo -e "${YELLOW}次のステップ:${NC}"
echo "1. backend/types/index.ts を更新（snake_case ⇔ camelCase変換）"
echo "2. ios/App/Domain/Entities/*.swift を更新（UUID → String変換）"
echo "3. backend/prisma/rls-policies.sql にRLSポリシー追加"
echo "4. docs/design/database/overall-schema.md を更新"
echo "5. Supabase SQL EditorでRLSポリシーを実行"
echo "6. npx prisma db push でSupabaseに反映"
echo ""
