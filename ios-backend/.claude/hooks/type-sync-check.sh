#!/bin/bash

# 型同期チェックhook
# Prismaスキーマ、backend types、iOSモデル、設計書の整合性をチェック

CHANGED_FILES="${CHANGED_FILES:-}"

# 型定義に関連するファイルが変更されたかチェック
if echo "$CHANGED_FILES" | grep -q "prisma/schema.prisma\|types/index.ts\|/Entities/.*\.swift\|overall-schema.md"; then
  echo "⚠️  型定義ファイルの変更を検出しました"
  echo ""
  echo "📋 型変更時のチェックリスト:"
  echo ""
  echo "以下の全ての箇所が同期されているか確認してください:"
  echo ""
  echo "1️⃣  Backend:"
  echo "   ✓ backend/prisma/schema.prisma"
  echo "   ✓ backend/types/index.ts (各種型定義)"
  echo "   ✓ prisma db push または prisma migrate dev 実行済み"
  echo ""
  echo "2️⃣  iOS:"
  echo "   ✓ ios/[プロジェクト名]/Domain/Entities/ 配下のモデル"
  echo ""
  echo "3️⃣  ドキュメント:"
  echo "   ✓ docs/design/database/overall-schema.md"
  echo ""

  # 変更されたファイルに応じて詳細な警告
  if echo "$CHANGED_FILES" | grep -q "prisma/schema.prisma"; then
    echo "🔍 Prismaスキーマが変更されました"
    echo "   → backend/types/index.ts を確認"
    echo "   → iOS Entitiesを確認"
    echo "   → docs/design/database/overall-schema.md を確認"
    echo ""
  fi

  if echo "$CHANGED_FILES" | grep -q "types/index.ts"; then
    echo "🔍 Backend型定義が変更されました"
    echo "   → Prismaスキーマと一致していますか？"
    echo "   → iOS Entitiesと一致していますか？"
    echo ""
  fi

  if echo "$CHANGED_FILES" | grep -q "/Entities/.*\.swift"; then
    echo "🔍 iOSモデルが変更されました"
    echo "   → Backend型定義と一致していますか？"
    echo "   → Prismaスキーマと一致していますか？"
    echo ""
  fi

  if echo "$CHANGED_FILES" | grep -q "overall-schema.md"; then
    echo "🔍 データベース設計書が更新されました"
    echo "   → Prismaスキーマと一致していますか？"
    echo ""
  fi

  echo "✅ 全ての箇所を確認したらこのメッセージを無視してください"
  echo ""
fi

exit 0
