import { NextResponse } from 'next/server';
import { ZodError } from 'zod';
import { Prisma } from '@prisma/client';

export function handleError(error: unknown): NextResponse {
  // Zodバリデーションエラー
  if (error instanceof ZodError) {
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

  // Prismaエラー
  if (error instanceof Prisma.PrismaClientKnownRequestError) {
    // ユニーク制約違反
    if (error.code === 'P2002') {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: 'DUPLICATE_ERROR',
            message: 'データが既に存在します',
            details: error.meta,
          },
        },
        { status: 409 }
      );
    }

    // レコードが見つからない
    if (error.code === 'P2025') {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: 'NOT_FOUND',
            message: 'データが見つかりません',
          },
        },
        { status: 404 }
      );
    }
  }

  // 一般的なエラー
  console.error('Unhandled error:', error);
  return NextResponse.json(
    {
      success: false,
      error: {
        code: 'INTERNAL_ERROR',
        message: 'サーバーエラーが発生しました',
      },
    },
    { status: 500 }
  );
}
