#!/bin/bash

# ============================================
# 型同期チェック Hook
# Prismaスキーマと型定義の同期を確認
# ============================================

echo "型同期チェックを実行中..."

# Prismaスキーマのモデル名を取得
PRISMA_MODELS=$(grep -E "^model " prisma/schema.prisma 2>/dev/null | awk '{print $2}')

if [ -z "$PRISMA_MODELS" ]; then
    echo "Prismaスキーマにモデルが見つかりません"
    exit 0
fi

# 型定義ファイルをチェック
TYPES_FILE="types/index.ts"

if [ ! -f "$TYPES_FILE" ]; then
    echo "警告: $TYPES_FILE が見つかりません"
    exit 0
fi

echo ""
echo "型同期チェックリスト:"
echo "====================="

MISSING=0
for model in $PRISMA_MODELS; do
    if grep -q "interface $model" "$TYPES_FILE" || grep -q "type $model" "$TYPES_FILE"; then
        echo "✓ $model - 型定義あり"
    else
        echo "✗ $model - 型定義なし"
        ((MISSING++))
    fi
done

echo ""

if [ $MISSING -gt 0 ]; then
    echo "警告: $MISSING 個のモデルに対応する型定義がありません"
    echo "types/index.ts を更新してください"
fi

exit 0
