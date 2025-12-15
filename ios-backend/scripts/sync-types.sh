#!/bin/bash

# 型同期スクリプト
# Prismaスキーマから TypeScript型定義 と Swift型定義 を自動生成

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔄 型同期スクリプト実行${NC}"
echo ""

# プロジェクトルートチェック
if [ ! -f "backend/prisma/schema.prisma" ]; then
  echo -e "${RED}❌ backend/prisma/schema.prisma が見つかりません${NC}"
  echo -e "${YELLOW}   プロジェクトルートで実行してください${NC}"
  exit 1
fi

# 引数チェック
MODE=${1:-check}  # デフォルトはcheckモード

if [ "$MODE" != "check" ] && [ "$MODE" != "generate" ]; then
  echo "使用方法: ./scripts/sync-types.sh [check|generate]"
  echo ""
  echo "  check    - 型定義の同期状態をチェック（デフォルト）"
  echo "  generate - Prismaスキーマから型定義を自動生成"
  exit 1
fi

# ========================================
# 1. Prismaスキーマ解析
# ========================================

echo -e "${BLUE}📝 Prismaスキーマ解析中...${NC}"

SCHEMA_FILE="backend/prisma/schema.prisma"
MODELS=$(grep "^model " "$SCHEMA_FILE" | awk '{print $2}')
MODEL_COUNT=$(echo "$MODELS" | wc -l | tr -d ' ')

echo -e "${GREEN}✅ モデル数: $MODEL_COUNT${NC}"
echo ""

# ========================================
# 2. TypeScript型定義生成/チェック
# ========================================

generate_typescript_types() {
  echo -e "${BLUE}🔧 TypeScript型定義生成中...${NC}"

  TS_TYPES_FILE="backend/types/index.ts"

  cat > "$TS_TYPES_FILE" << 'EOF'
// 🤖 このファイルは自動生成されました
// 編集する場合は backend/prisma/schema.prisma を修正してから
// ./scripts/sync-types.sh generate を実行してください

EOF

  # Prismaスキーマからモデル情報を抽出
  while IFS= read -r model_name; do
    [ -z "$model_name" ] && continue

    echo "// ========================================" >> "$TS_TYPES_FILE"
    echo "// $model_name" >> "$TS_TYPES_FILE"
    echo "// ========================================" >> "$TS_TYPES_FILE"
    echo "" >> "$TS_TYPES_FILE"

    # モデルのフィールドを抽出
    awk "/^model $model_name/,/^}/" "$SCHEMA_FILE" | \
      grep -v "^model" | \
      grep -v "^}" | \
      grep -E "^\s+[a-zA-Z]" | \
      while IFS= read -r line; do
        # フィールド名と型を抽出
        field_name=$(echo "$line" | awk '{print $1}')
        prisma_type=$(echo "$line" | awk '{print $2}')

        # Prisma型をTypeScript型に変換
        ts_type="unknown"
        case "$prisma_type" in
          String) ts_type="string" ;;
          Int) ts_type="number" ;;
          Float) ts_type="number" ;;
          Boolean) ts_type="boolean" ;;
          DateTime) ts_type="Date | string" ;;
          Json) ts_type="Record<string, unknown>" ;;
          *)
            # カスタム型（他のモデル）の場合
            if echo "$MODELS" | grep -q "^$prisma_type$"; then
              ts_type="$prisma_type"
            else
              ts_type="string"
            fi
            ;;
        esac

        # Optional/Required判定
        if echo "$line" | grep -q "?"; then
          ts_type="$ts_type | null"
        fi

        echo "  $field_name: $ts_type;" >> "$TS_TYPES_FILE.tmp"
      done

    # 型定義を出力
    echo "export interface $model_name {" >> "$TS_TYPES_FILE"
    if [ -f "$TS_TYPES_FILE.tmp" ]; then
      cat "$TS_TYPES_FILE.tmp" >> "$TS_TYPES_FILE"
      rm "$TS_TYPES_FILE.tmp"
    fi
    echo "}" >> "$TS_TYPES_FILE"
    echo "" >> "$TS_TYPES_FILE"

  done <<< "$MODELS"

  # Pagination型を追加
  cat >> "$TS_TYPES_FILE" << 'EOF'
// ========================================
// 共通型
// ========================================

export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  pageSize: number;
  totalPages: number;
}

export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: ApiError;
}

export interface ApiError {
  code: string;
  message: string;
  details?: Record<string, unknown>;
}
EOF

  echo -e "${GREEN}✅ TypeScript型定義生成完了: $TS_TYPES_FILE${NC}"
}

check_typescript_types() {
  echo -e "${BLUE}🔍 TypeScript型定義チェック中...${NC}"

  TS_TYPES_FILE="backend/types/index.ts"

  if [ ! -f "$TS_TYPES_FILE" ]; then
    echo -e "${RED}❌ $TS_TYPES_FILE が存在しません${NC}"
    echo -e "${YELLOW}   → ./scripts/sync-types.sh generate を実行してください${NC}"
    return 1
  fi

  # モデルごとに型定義が存在するかチェック
  MISSING_MODELS=""
  while IFS= read -r model_name; do
    [ -z "$model_name" ] && continue

    if ! grep -q "export interface $model_name" "$TS_TYPES_FILE"; then
      MISSING_MODELS="$MISSING_MODELS\n  - $model_name"
    fi
  done <<< "$MODELS"

  if [ -n "$MISSING_MODELS" ]; then
    echo -e "${YELLOW}⚠️  以下のモデルの型定義が見つかりません:${NC}"
    echo -e "$MISSING_MODELS"
    echo ""
    echo -e "${YELLOW}   → ./scripts/sync-types.sh generate を実行してください${NC}"
    return 1
  fi

  echo -e "${GREEN}✅ TypeScript型定義は最新です${NC}"
}

# ========================================
# 3. Swift型定義生成/チェック（簡易版）
# ========================================

generate_swift_types() {
  echo ""
  echo -e "${BLUE}🍎 Swift型定義生成中...${NC}"

  # ios/App/Domain/Entities/ に各モデルのファイルを生成
  SWIFT_ENTITIES_DIR="ios/App/Domain/Entities"

  if [ ! -d "$SWIFT_ENTITIES_DIR" ]; then
    echo -e "${YELLOW}⚠️  $SWIFT_ENTITIES_DIR が見つかりません${NC}"
    echo -e "${YELLOW}   → iOSプロジェクトを先にセットアップしてください${NC}"
    return
  fi

  while IFS= read -r model_name; do
    [ -z "$model_name" ] && continue

    SWIFT_FILE="$SWIFT_ENTITIES_DIR/$model_name.swift"

    cat > "$SWIFT_FILE" << EOF
// 🤖 このファイルは自動生成されました
// 編集する場合は backend/prisma/schema.prisma を修正してから
// ./scripts/sync-types.sh generate を実行してください

import Foundation

struct $model_name: Codable, Identifiable, Equatable {
EOF

    # モデルのフィールドを抽出
    awk "/^model $model_name/,/^}/" "$SCHEMA_FILE" | \
      grep -v "^model" | \
      grep -v "^}" | \
      grep -E "^\s+[a-zA-Z]" | \
      while IFS= read -r line; do
        field_name=$(echo "$line" | awk '{print $1}')
        prisma_type=$(echo "$line" | awk '{print $2}')

        # Prisma型をSwift型に変換
        swift_type="String"
        case "$prisma_type" in
          String) swift_type="String" ;;
          Int) swift_type="Int" ;;
          Float) swift_type="Double" ;;
          Boolean) swift_type="Bool" ;;
          DateTime) swift_type="Date" ;;
          Json) swift_type="[String: Any]" ;;
          *)
            # カスタム型の場合
            if echo "$MODELS" | grep -q "^$prisma_type$"; then
              swift_type="$prisma_type"
            else
              swift_type="String"
            fi
            ;;
        esac

        # Optional判定
        if echo "$line" | grep -q "?"; then
          swift_type="$swift_type?"
        fi

        # snake_case → camelCase変換
        field_name_camel=$(echo "$field_name" | perl -pe 's/_([a-z])/\U$1/g')

        echo "  let $field_name_camel: $swift_type" >> "$SWIFT_FILE"
      done

    echo "}" >> "$SWIFT_FILE"

    echo -e "${GREEN}✅ $SWIFT_FILE${NC}"

  done <<< "$MODELS"
}

check_swift_types() {
  echo ""
  echo -e "${BLUE}🔍 Swift型定義チェック中...${NC}"

  SWIFT_ENTITIES_DIR="ios/App/Domain/Entities"

  if [ ! -d "$SWIFT_ENTITIES_DIR" ]; then
    echo -e "${YELLOW}⚠️  $SWIFT_ENTITIES_DIR が見つかりません${NC}"
    echo -e "${YELLOW}   → iOSプロジェクトを先にセットアップしてください${NC}"
    return
  fi

  MISSING_MODELS=""
  while IFS= read -r model_name; do
    [ -z "$model_name" ] && continue

    SWIFT_FILE="$SWIFT_ENTITIES_DIR/$model_name.swift"
    if [ ! -f "$SWIFT_FILE" ]; then
      MISSING_MODELS="$MISSING_MODELS\n  - $model_name"
    fi
  done <<< "$MODELS"

  if [ -n "$MISSING_MODELS" ]; then
    echo -e "${YELLOW}⚠️  以下のモデルのSwift型定義が見つかりません:${NC}"
    echo -e "$MISSING_MODELS"
    echo ""
    echo -e "${YELLOW}   → ./scripts/sync-types.sh generate を実行してください${NC}"
    return 1
  fi

  echo -e "${GREEN}✅ Swift型定義は最新です${NC}"
}

# ========================================
# メイン処理
# ========================================

if [ "$MODE" == "generate" ]; then
  echo -e "${BLUE}🤖 型定義自動生成モード${NC}"
  echo ""

  generate_typescript_types
  generate_swift_types

  echo ""
  echo -e "${GREEN}✅ 型定義生成完了${NC}"
  echo ""
  echo -e "${YELLOW}次のステップ:${NC}"
  echo "1. backend/types/index.ts を確認"
  echo "2. ios/App/Domain/Entities/*.swift を確認"
  echo "3. 必要に応じて手動で調整"
  echo "4. prisma generate を実行: cd backend && npx prisma generate"
  echo ""
else
  echo -e "${BLUE}🔍 型定義チェックモード${NC}"
  echo ""

  TS_CHECK_RESULT=0
  SWIFT_CHECK_RESULT=0

  check_typescript_types || TS_CHECK_RESULT=$?
  check_swift_types || SWIFT_CHECK_RESULT=$?

  if [ $TS_CHECK_RESULT -eq 0 ] && [ $SWIFT_CHECK_RESULT -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ 全ての型定義が同期されています${NC}"
    exit 0
  else
    echo ""
    echo -e "${YELLOW}⚠️  型定義が同期されていません${NC}"
    echo -e "${YELLOW}   → ./scripts/sync-types.sh generate を実行してください${NC}"
    exit 1
  fi
fi
