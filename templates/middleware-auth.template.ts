import { NextRequest, NextResponse } from 'next/server';
import { withAuth, AuthenticatedRequest } from '@/middleware/auth';

// 認証が必要なAPIエンドポイントの例

// GET /api/{{RESOURCE_KEBAB}} (認証必須)
export const GET = withAuth(async (req: AuthenticatedRequest) => {
  try {
    // req.user でログインユーザー情報にアクセス可能
    const userId = req.user?.userId;

    // TODO: ビジネスロジック実装

    return NextResponse.json({
      success: true,
      data: {
        message: `User ${userId} からのリクエスト`,
      },
    });
  } catch (error) {
    return NextResponse.json(
      {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: 'サーバーエラー',
        },
      },
      { status: 500 }
    );
  }
});
