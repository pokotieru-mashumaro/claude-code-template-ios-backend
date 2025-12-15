import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/db/prisma';
import { z } from 'zod';

// バリデーションスキーマ
const {{RESOURCE_NAME}}Schema = z.object({
  // TODO: フィールドを定義
  name: z.string().min(1).max(100),
});

// GET /api/{{RESOURCE_KEBAB}}
export async function GET(req: NextRequest) {
  try {
    // クエリパラメータ取得
    const { searchParams } = new URL(req.url);
    const page = parseInt(searchParams.get('page') || '1');
    const limit = parseInt(searchParams.get('limit') || '20');
    const skip = (page - 1) * limit;

    // データ取得
    const [{{RESOURCE_LOWER}}s, total] = await Promise.all([
      prisma.{{RESOURCE_LOWER}}.findMany({
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
      }),
      prisma.{{RESOURCE_LOWER}}.count(),
    ]);

    return NextResponse.json({
      success: true,
      data: {
        {{RESOURCE_LOWER}}s,
        pagination: {
          page,
          limit,
          total,
          totalPages: Math.ceil(total / limit),
        },
      },
    });
  } catch (error) {
    console.error('Error fetching {{RESOURCE_LOWER}}s:', error);
    return NextResponse.json(
      {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: '{{RESOURCE_NAME}}の取得に失敗しました',
        },
      },
      { status: 500 }
    );
  }
}

// POST /api/{{RESOURCE_KEBAB}}
export async function POST(req: NextRequest) {
  try {
    const body = await req.json();

    // バリデーション
    const validatedData = {{RESOURCE_NAME}}Schema.parse(body);

    // データ作成
    const {{RESOURCE_LOWER}} = await prisma.{{RESOURCE_LOWER}}.create({
      data: validatedData,
    });

    return NextResponse.json(
      {
        success: true,
        data: {{RESOURCE_LOWER}},
      },
      { status: 201 }
    );
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: 'VALIDATION_ERROR',
            message: 'バリデーションエラー',
            details: error.errors,
          },
        },
        { status: 400 }
      );
    }

    console.error('Error creating {{RESOURCE_LOWER}}:', error);
    return NextResponse.json(
      {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: '{{RESOURCE_NAME}}の作成に失敗しました',
        },
      },
      { status: 500 }
    );
  }
}
