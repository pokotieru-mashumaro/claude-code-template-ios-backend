#!/bin/bash

# 機能自動生成スクリプト
# 使用方法: ./scripts/generate-feature.sh <feature-name> <type>
# 例: ./scripts/generate-feature.sh User crud

set -e

# 色定義
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 引数チェック
if [ $# -lt 2 ]; then
    echo "使用方法: ./scripts/generate-feature.sh <feature-name> <type>"
    echo ""
    echo "Types:"
    echo "  crud    - CRUD機能の完全な実装"
    echo "  api     - APIエンドポイントのみ"
    echo "  ios     - iOSの画面とViewModel"
    echo "  docs    - ドキュメントのみ"
    exit 1
fi

FEATURE_NAME=$1
TYPE=$2
FEATURE_LOWER=$(echo "$FEATURE_NAME" | tr '[:upper:]' '[:lower:]')
FEATURE_KEBAB=$(echo "$FEATURE_NAME" | sed 's/\([A-Z]\)/-\1/g' | tr '[:upper:]' '[:lower:]' | sed 's/^-//')

echo -e "${BLUE}🚀 機能生成: $FEATURE_NAME (タイプ: $TYPE)${NC}"
echo ""

# ドキュメント生成
generate_docs() {
    echo -e "${GREEN}📝 ドキュメント生成中...${NC}"

    mkdir -p docs/requirements

    cat > "docs/requirements/${FEATURE_KEBAB}.md" << EOF
# ${FEATURE_NAME}機能

> このファイルは自動生成されたテンプレートです。内容を編集してください。

---

## 概要

[${FEATURE_NAME}機能の概要を記述]

---

## 機能要件

### 基本機能

#### 1. ${FEATURE_NAME}一覧表示
- 全ての${FEATURE_NAME}を一覧表示
- ページネーション対応

#### 2. ${FEATURE_NAME}詳細表示
- 指定した${FEATURE_NAME}の詳細情報を表示

#### 3. ${FEATURE_NAME}作成
- 新しい${FEATURE_NAME}を作成

#### 4. ${FEATURE_NAME}編集
- 既存の${FEATURE_NAME}を編集

#### 5. ${FEATURE_NAME}削除
- 既存の${FEATURE_NAME}を削除

---

## UI/UX仕様

### 画面構成
- ${FEATURE_NAME}一覧画面
- ${FEATURE_NAME}詳細画面
- ${FEATURE_NAME}作成/編集画面

---

## バリデーションルール

[バリデーションルールを記述]

---

## エラーハンドリング

[エラーケースを記述]

---

**最終更新日**: $(date +%Y-%m-%d)
EOF

    echo -e "${GREEN}✅ ドキュメント生成完了: docs/requirements/${FEATURE_KEBAB}.md${NC}"
}

# Backend API生成
generate_backend_api() {
    echo -e "${GREEN}🔧 Backend API生成中...${NC}"

    mkdir -p "backend/app/api/${FEATURE_KEBAB}"

    # GET /api/[resource]
    mkdir -p "backend/app/api/${FEATURE_KEBAB}"
    cat > "backend/app/api/${FEATURE_KEBAB}/route.ts" << EOF
import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/db/prisma';

// GET /api/${FEATURE_KEBAB}
export async function GET(req: NextRequest) {
  try {
    const ${FEATURE_LOWER}s = await prisma.${FEATURE_LOWER}.findMany({
      orderBy: { createdAt: 'desc' },
    });

    return NextResponse.json({
      success: true,
      data: ${FEATURE_LOWER}s,
    });
  } catch (error) {
    console.error('Error fetching ${FEATURE_LOWER}s:', error);
    return NextResponse.json(
      {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: '${FEATURE_NAME}の取得に失敗しました',
        },
      },
      { status: 500 }
    );
  }
}

// POST /api/${FEATURE_KEBAB}
export async function POST(req: NextRequest) {
  try {
    const body = await req.json();

    // TODO: バリデーション追加

    const ${FEATURE_LOWER} = await prisma.${FEATURE_LOWER}.create({
      data: body,
    });

    return NextResponse.json(
      {
        success: true,
        data: ${FEATURE_LOWER},
      },
      { status: 201 }
    );
  } catch (error) {
    console.error('Error creating ${FEATURE_LOWER}:', error);
    return NextResponse.json(
      {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: '${FEATURE_NAME}の作成に失敗しました',
        },
      },
      { status: 500 }
    );
  }
}
EOF

    # GET/PUT/DELETE /api/[resource]/[id]
    mkdir -p "backend/app/api/${FEATURE_KEBAB}/[id]"
    cat > "backend/app/api/${FEATURE_KEBAB}/[id]/route.ts" << EOF
import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/db/prisma';

// GET /api/${FEATURE_KEBAB}/[id]
export async function GET(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const ${FEATURE_LOWER} = await prisma.${FEATURE_LOWER}.findUnique({
      where: { id: params.id },
    });

    if (!${FEATURE_LOWER}) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: 'NOT_FOUND',
            message: '${FEATURE_NAME}が見つかりません',
          },
        },
        { status: 404 }
      );
    }

    return NextResponse.json({
      success: true,
      data: ${FEATURE_LOWER},
    });
  } catch (error) {
    console.error('Error fetching ${FEATURE_LOWER}:', error);
    return NextResponse.json(
      {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: '${FEATURE_NAME}の取得に失敗しました',
        },
      },
      { status: 500 }
    );
  }
}

// PUT /api/${FEATURE_KEBAB}/[id]
export async function PUT(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const body = await req.json();

    // TODO: バリデーション追加

    const ${FEATURE_LOWER} = await prisma.${FEATURE_LOWER}.update({
      where: { id: params.id },
      data: body,
    });

    return NextResponse.json({
      success: true,
      data: ${FEATURE_LOWER},
    });
  } catch (error) {
    console.error('Error updating ${FEATURE_LOWER}:', error);
    return NextResponse.json(
      {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: '${FEATURE_NAME}の更新に失敗しました',
        },
      },
      { status: 500 }
    );
  }
}

// DELETE /api/${FEATURE_KEBAB}/[id]
export async function DELETE(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    await prisma.${FEATURE_LOWER}.delete({
      where: { id: params.id },
    });

    return NextResponse.json({
      success: true,
      data: null,
    });
  } catch (error) {
    console.error('Error deleting ${FEATURE_LOWER}:', error);
    return NextResponse.json(
      {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: '${FEATURE_NAME}の削除に失敗しました',
        },
      },
      { status: 500 }
    );
  }
}
EOF

    echo -e "${GREEN}✅ Backend API生成完了${NC}"
    echo -e "  - backend/app/api/${FEATURE_KEBAB}/route.ts"
    echo -e "  - backend/app/api/${FEATURE_KEBAB}/[id]/route.ts"
}

# iOS画面生成
generate_ios_ui() {
    echo -e "${GREEN}📱 iOS UI生成中...${NC}"

    # TODO: iOSプロジェクトが存在する場合のみ生成
    if [ -d "ios" ]; then
        echo -e "${YELLOW}⚠️  iOS UI生成はまだ実装されていません${NC}"
        echo -e "${YELLOW}   手動で以下のファイルを作成してください:${NC}"
        echo -e "   - ios/[ProjectName]/Presentation/Views/${FEATURE_NAME}/"
        echo -e "   - ios/[ProjectName]/Presentation/ViewModels/${FEATURE_NAME}/"
        echo -e "   - ios/[ProjectName]/Domain/UseCases/${FEATURE_NAME}/"
    else
        echo -e "${YELLOW}⚠️  iOSディレクトリが見つかりません${NC}"
    fi
}

# メイン処理
case $TYPE in
    crud)
        generate_docs
        generate_backend_api
        generate_ios_ui
        ;;
    api)
        generate_backend_api
        ;;
    ios)
        generate_ios_ui
        ;;
    docs)
        generate_docs
        ;;
    *)
        echo "❌ 不明なタイプ: $TYPE"
        exit 1
        ;;
esac

echo ""
echo -e "${BLUE}✨ 完了！${NC}"
echo ""
echo -e "${YELLOW}次のステップ:${NC}"
echo "1. 生成されたドキュメントを編集"
echo "2. Prismaスキーマに${FEATURE_NAME}モデルを追加（backend/prisma/schema.prisma）"
echo "3. データベースにマイグレーション: npx prisma db push"
echo "4. Supabase RLSポリシーを追加（backend/prisma/rls-policies.sql）"
echo "5. バリデーションを追加（Zodスキーマ）"
echo "6. 認証ミドルウェアを適用（必要に応じて withSupabaseAuth）"
echo ""
