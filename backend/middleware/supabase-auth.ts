import { NextRequest, NextResponse } from 'next/server';
import { supabaseAdmin } from '@/lib/auth/supabase';

export interface AuthenticatedRequest extends NextRequest {
  user?: {
    id: string;
    email: string;
    [key: string]: unknown;
  };
}

export function withSupabaseAuth(
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

      // Supabaseでトークン検証
      const { data, error } = await supabaseAdmin.auth.getUser(token);

      if (error || !data.user) {
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

      // リクエストにユーザー情報を追加
      req.user = {
        id: data.user.id,
        email: data.user.email!,
        ...data.user.user_metadata,
      };

      return await handler(req, context);
    } catch (error) {
      console.error('Auth error:', error);
      return NextResponse.json(
        {
          success: false,
          error: {
            code: 'UNAUTHORIZED',
            message: '認証エラー',
          },
        },
        { status: 401 }
      );
    }
  };
}
