import { NextRequest, NextResponse } from 'next/server';
import { withSupabaseAuth, AuthenticatedRequest } from '@/middleware/supabase-auth';

// 認証が必要なAPIエンドポイントの例

// GET /api/{{RESOURCE_KEBAB}} (認証必須)
export const GET = withSupabaseAuth(async (req: AuthenticatedRequest) => {
  try {
    // req.user でログインユーザー情報にアクセス可能（Supabase Auth）
    const userId = req.user?.id;
    const userEmail = req.user?.email;

    // TODO: ビジネスロジック実装

    return NextResponse.json({
      success: true,
      data: {
        message: `User ${userId} (${userEmail}) からのリクエスト`,
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
