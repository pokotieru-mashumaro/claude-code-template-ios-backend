import { NextRequest, NextResponse } from 'next/server';
import { verifyAccessToken } from '@/lib/auth/jwt';
import { JwtPayload } from '@/types';

export interface AuthenticatedRequest extends NextRequest {
  user?: JwtPayload;
}

export function withAuth(
  handler: (req: AuthenticatedRequest, context?: unknown) => Promise<NextResponse>
) {
  return async (req: AuthenticatedRequest, context?: unknown) => {
    try {
      const authHeader = req.headers.get('authorization');

      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return NextResponse.json(
          {
            success: false,
            error: {
              code: 'UNAUTHORIZED',
              message: '認証が必要です',
            },
          },
          { status: 401 }
        );
      }

      const token = authHeader.substring(7);
      const payload = verifyAccessToken(token);

      // リクエストにユーザー情報を追加
      req.user = payload;

      return await handler(req, context);
    } catch (error) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: 'UNAUTHORIZED',
            message: 'トークンが無効です',
          },
        },
        { status: 401 }
      );
    }
  };
}
