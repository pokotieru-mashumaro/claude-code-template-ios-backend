// ============================================
// API Route テンプレート
// ファイル名: app/api/[feature]/route.ts
// ============================================

import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { prisma } from '@/lib/db/prisma';

// バリデーションスキーマ
const CreateSchema = z.object({
  // TODO: フィールドを定義
  name: z.string().min(1).max(100),
});

// GET: 一覧取得
export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams;
    const page = parseInt(searchParams.get('page') || '1');
    const limit = parseInt(searchParams.get('limit') || '20');
    const skip = (page - 1) * limit;

    // TODO: 認証チェック

    // TODO: データ取得ロジック
    const [data, total] = await Promise.all([
      prisma.user.findMany({
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
      }),
      prisma.user.count(),
    ]);

    return NextResponse.json({
      data,
      pagination: {
        page,
        limit,
        total,
        hasMore: skip + data.length < total,
      },
    });
  } catch (error) {
    console.error('GET error:', error);
    return NextResponse.json(
      { error: { message: 'データの取得に失敗しました' } },
      { status: 500 }
    );
  }
}

// POST: 新規作成
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    // バリデーション
    const validationResult = CreateSchema.safeParse(body);
    if (!validationResult.success) {
      return NextResponse.json(
        { error: { message: 'バリデーションエラー', details: validationResult.error.flatten() } },
        { status: 400 }
      );
    }

    // TODO: 認証チェック

    // TODO: 作成ロジック
    const created = await prisma.user.create({
      data: validationResult.data,
    });

    return NextResponse.json({ data: created }, { status: 201 });
  } catch (error) {
    console.error('POST error:', error);
    return NextResponse.json(
      { error: { message: '作成に失敗しました' } },
      { status: 500 }
    );
  }
}
