#!/bin/bash

# プロジェクト検証スクリプト
# 設計フェーズ（Phase 0）完了時に実行

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔍 プロジェクト検証開始${NC}"
echo ""

ERROR_COUNT=0
WARNING_COUNT=0

# 必須ドキュメントチェック
check_required_docs() {
  echo -e "${BLUE}📋 必須ドキュメントチェック...${NC}"

  REQUIRED_DOCS=(
    "docs/requirements:少なくとも1つの要件定義ファイルが必要"
    "docs/design/database/overall-schema.md:データベース設計は必須"
    "docs/design/api/endpoints.md:API設計は必須"
    "docs/design/architecture/system-architecture.md:アーキテクチャ設計は必須"
    "docs/design/architecture/directory-structure.md:ディレクトリ構成は必須"
    "docs/project-management/implementation-phases.md:実装計画は必須"
    "docs/project-management/coding-standards.md:コーディング規約は必須"
  )

  for item in "${REQUIRED_DOCS[@]}"; do
    path="${item%%:*}"
    description="${item##*:}"

    if [[ "$path" == *"/"* ]] && [[ "$path" != *".md" ]]; then
      # ディレクトリの場合、中にファイルがあるかチェック
      if [ -d "$path" ] && [ "$(ls -A $path)" ]; then
        echo -e "${GREEN}✅ $path${NC}"
      else
        echo -e "${RED}❌ $path ($description)${NC}"
        ((ERROR_COUNT++))
      fi
    else
      # ファイルの場合
      if [ -f "$path" ]; then
        # TODOや未記入が残っていないかチェック
        TODO_COUNT=$(grep -c "\[記入\]\|\[日付\]\|\[プロジェクト" "$path" 2>/dev/null || echo "0")
        if [ "$TODO_COUNT" -gt 0 ]; then
          echo -e "${YELLOW}⚠️  $path (未記入項目: $TODO_COUNT)${NC}"
          ((WARNING_COUNT++))
        else
          echo -e "${GREEN}✅ $path${NC}"
        fi
      else
        echo -e "${RED}❌ $path ($description)${NC}"
        ((ERROR_COUNT++))
      fi
    fi
  done
}

# Prismaスキーマチェック
check_prisma_schema() {
  echo ""
  echo -e "${BLUE}🔨 Prismaスキーマチェック...${NC}"

  if [ -f "backend/prisma/schema.prisma" ]; then
    # モデル数をカウント
    MODEL_COUNT=$(grep -c "^model " "backend/prisma/schema.prisma" || echo "0")

    if [ "$MODEL_COUNT" -eq 0 ]; then
      echo -e "${RED}❌ Prismaスキーマにモデルが定義されていません${NC}"
      ((ERROR_COUNT++))
    elif [ "$MODEL_COUNT" -lt 3 ]; then
      echo -e "${YELLOW}⚠️  Prismaスキーマのモデル数が少ないです（$MODEL_COUNT個）${NC}"
      ((WARNING_COUNT++))
    else
      echo -e "${GREEN}✅ Prismaスキーマ（$MODEL_COUNT モデル）${NC}"
    fi

    # User モデルの存在確認
    if ! grep -q "^model User" "backend/prisma/schema.prisma"; then
      echo -e "${YELLOW}⚠️  User モデルが見つかりません${NC}"
      ((WARNING_COUNT++))
    fi
  else
    echo -e "${YELLOW}⚠️  backend/prisma/schema.prisma が見つかりません${NC}"
    ((WARNING_COUNT++))
  fi
}

# API設計チェック
check_api_design() {
  echo ""
  echo -e "${BLUE}🌐 API設計チェック...${NC}"

  if [ -f "docs/design/api/endpoints.md" ]; then
    # エンドポイント数をカウント（### POST, GET等）
    ENDPOINT_COUNT=$(grep -c "^### [A-Z]* /" "docs/design/api/endpoints.md" || echo "0")

    if [ "$ENDPOINT_COUNT" -eq 0 ]; then
      echo -e "${RED}❌ APIエンドポイントが定義されていません${NC}"
      ((ERROR_COUNT++))
    elif [ "$ENDPOINT_COUNT" -lt 5 ]; then
      echo -e "${YELLOW}⚠️  APIエンドポイント数が少ないです（$ENDPOINT_COUNT個）${NC}"
      ((WARNING_COUNT++))
    else
      echo -e "${GREEN}✅ APIエンドポイント（$ENDPOINT_COUNT個）${NC}"
    fi
  fi
}

# .claude設定チェック
check_claude_config() {
  echo ""
  echo -e "${BLUE}🤖 Claude Code設定チェック...${NC}"

  if [ -f ".claude/CLAUDE.md" ]; then
    # プロジェクト名が記入されているか
    if grep -q "\[プロジェクト名" ".claude/CLAUDE.md"; then
      echo -e "${YELLOW}⚠️  .claude/CLAUDE.md のプロジェクト名が未記入です${NC}"
      ((WARNING_COUNT++))
    else
      echo -e "${GREEN}✅ .claude/CLAUDE.md${NC}"
    fi
  else
    echo -e "${RED}❌ .claude/CLAUDE.md が見つかりません${NC}"
    ((ERROR_COUNT++))
  fi

  # Hooksの実行権限チェック
  if [ -d ".claude/hooks" ]; then
    for hook in .claude/hooks/*.sh; do
      if [ -x "$hook" ]; then
        echo -e "${GREEN}✅ $hook (実行可能)${NC}"
      else
        echo -e "${YELLOW}⚠️  $hook (実行権限なし)${NC}"
        echo -e "${YELLOW}   → chmod +x $hook を実行してください${NC}"
        ((WARNING_COUNT++))
      fi
    done
  fi
}

# gitignoreチェック
check_gitignore() {
  echo ""
  echo -e "${BLUE}📝 .gitignoreチェック...${NC}"

  if [ ! -f ".gitignore" ]; then
    echo -e "${RED}❌ .gitignore が見つかりません${NC}"
    ((ERROR_COUNT++))
    return
  fi

  REQUIRED_IGNORES=(
    ".env"
    "node_modules"
    ".DS_Store"
  )

  for pattern in "${REQUIRED_IGNORES[@]}"; do
    if grep -q "$pattern" ".gitignore"; then
      echo -e "${GREEN}✅ $pattern${NC}"
    else
      echo -e "${YELLOW}⚠️  $pattern が .gitignore に含まれていません${NC}"
      ((WARNING_COUNT++))
    fi
  done
}

# 実装フェーズチェック
check_implementation_phases() {
  echo ""
  echo -e "${BLUE}📅 実装フェーズチェック...${NC}"

  if [ -f "docs/project-management/implementation-phases.md" ]; then
    # Phase 0が完了しているかチェック
    if grep -q "Phase 0.*完了\|Phase 0.*✅" "docs/project-management/implementation-phases.md"; then
      echo -e "${GREEN}✅ Phase 0（設計フェーズ）完了マーク済み${NC}"
    else
      echo -e "${YELLOW}⚠️  Phase 0（設計フェーズ）が完了していません${NC}"
      echo -e "${YELLOW}   → 全ての設計が完了したらマークしてください${NC}"
      ((WARNING_COUNT++))
    fi
  fi
}

# メイン処理
check_required_docs
check_prisma_schema
check_api_design
check_claude_config
check_gitignore
check_implementation_phases

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 結果サマリー
if [ $ERROR_COUNT -eq 0 ] && [ $WARNING_COUNT -eq 0 ]; then
  echo -e "${GREEN}✅ プロジェクト検証完了: 問題なし${NC}"
  echo ""
  echo -e "${BLUE}🚀 Phase 1（実装フェーズ）を開始できます！${NC}"
  exit 0
elif [ $ERROR_COUNT -eq 0 ]; then
  echo -e "${YELLOW}⚠️  プロジェクト検証完了: ${WARNING_COUNT}件の警告${NC}"
  echo ""
  echo -e "${BLUE}Phase 1開始は可能ですが、警告を確認してください${NC}"
  exit 0
else
  echo -e "${RED}❌ プロジェクト検証失敗: ${ERROR_COUNT}件のエラー, ${WARNING_COUNT}件の警告${NC}"
  echo ""
  echo -e "${YELLOW}エラーを修正してから Phase 1を開始してください${NC}"
  exit 1
fi
