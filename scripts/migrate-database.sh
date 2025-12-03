#!/bin/bash

# データベースマイグレーション管理スクリプト
# 使用方法:
#   ./scripts/migrate-database.sh dev      # 開発環境でマイグレーション作成・適用
#   ./scripts/migrate-database.sh deploy   # 本番環境でマイグレーション適用
#   ./scripts/migrate-database.sh status   # マイグレーション状態確認
#   ./scripts/migrate-database.sh reset    # データベースリセット

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

MODE=${1:-dev}

echo -e "${BLUE}🔄 データベースマイグレーション: $MODE${NC}"
echo ""

# backendディレクトリの確認
if [ ! -d "backend" ]; then
  echo -e "${RED}❌ backendディレクトリが見つかりません${NC}"
  exit 1
fi

cd backend

# .envファイルの確認
if [ ! -f ".env" ]; then
  echo -e "${RED}❌ .envファイルが見つかりません${NC}"
  echo -e "${YELLOW}   backend/.envを作成してください${NC}"
  exit 1
fi

case $MODE in
  dev)
    echo -e "${BLUE}📝 開発環境マイグレーション作成・適用${NC}"
    echo ""
    read -p "マイグレーション名を入力してください: " MIGRATION_NAME

    if [ -z "$MIGRATION_NAME" ]; then
      echo -e "${RED}❌ マイグレーション名が必要です${NC}"
      exit 1
    fi

    npx prisma migrate dev --name "$MIGRATION_NAME"

    echo ""
    echo -e "${GREEN}✅ マイグレーション作成・適用完了${NC}"
    echo -e "${YELLOW}   prisma/migrations/ に新しいマイグレーションファイルが作成されました${NC}"
    ;;

  deploy)
    echo -e "${BLUE}🚀 本番環境マイグレーション適用${NC}"
    echo ""
    echo -e "${RED}⚠️  本番環境のデータベースに変更を加えます${NC}"
    read -p "続行しますか？ (yes/no): " CONFIRM

    if [ "$CONFIRM" != "yes" ]; then
      echo -e "${YELLOW}キャンセルしました${NC}"
      exit 0
    fi

    npx prisma migrate deploy

    echo ""
    echo -e "${GREEN}✅ マイグレーション適用完了${NC}"
    ;;

  status)
    echo -e "${BLUE}📊 マイグレーション状態確認${NC}"
    echo ""
    npx prisma migrate status
    ;;

  reset)
    echo -e "${RED}⚠️  データベースリセット${NC}"
    echo -e "${RED}   全てのデータが削除されます！${NC}"
    echo ""
    read -p "本当にリセットしますか？ (yes/no): " CONFIRM

    if [ "$CONFIRM" != "yes" ]; then
      echo -e "${YELLOW}キャンセルしました${NC}"
      exit 0
    fi

    npx prisma migrate reset

    echo ""
    echo -e "${GREEN}✅ データベースリセット完了${NC}"
    echo -e "${YELLOW}   シードデータを投入する場合: npm run prisma:seed${NC}"
    ;;

  *)
    echo -e "${RED}❌ 不明なモード: $MODE${NC}"
    echo ""
    echo "使用方法:"
    echo "  ./scripts/migrate-database.sh dev      # 開発環境でマイグレーション作成・適用"
    echo "  ./scripts/migrate-database.sh deploy   # 本番環境でマイグレーション適用"
    echo "  ./scripts/migrate-database.sh status   # マイグレーション状態確認"
    echo "  ./scripts/migrate-database.sh reset    # データベースリセット"
    exit 1
    ;;
esac

echo ""
