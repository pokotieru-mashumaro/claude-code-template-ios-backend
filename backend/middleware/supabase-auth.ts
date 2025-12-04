import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY!;

// サービスロールキーを使用したSupabaseクライアント（RLSバイパス）
const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey);

export interface AuthenticatedRequest extends NextRequest {
  user: {
    id: string;
    email?: string;
    role?: string;
  };
}

/**
 * Supabase認証ミドルウェア
 *
 * リクエストヘッダーのAuthorizationからJWTトークンを検証し、
 * 有効なユーザー情報をコンテキストに追加します
 *
 * @param handler - 認証後に実行するハンドラー関数
 * @returns Next.js API Routeハンドラー
 */
export function withSupabaseAuth<T>(
  handler: (req: AuthenticatedRequest, context: T) => Promise<NextResponse>
) {
  return async (req: NextRequest, context: T): Promise<NextResponse> => {
    try {
      // Authorizationヘッダーからトークンを取得
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

      const token = authHeader.replace('Bearer ', '');

      // JWTトークンを検証
      const {
        data: { user },
        error,
      } = await supabaseAdmin.auth.getUser(token);

      if (error || !user) {
        return NextResponse.json(
          {
            success: false,
            error: {
              code: 'UNAUTHORIZED',
              message: '無効なトークンです',
            },
          },
          { status: 401 }
        );
      }

      // ユーザー情報をリクエストに追加
      const authenticatedReq = req as AuthenticatedRequest;
      authenticatedReq.user = {
        id: user.id,
        email: user.email,
        role: user.role,
      };

      // 元のハンドラーを実行
      return await handler(authenticatedReq, context);
    } catch (error) {
      console.error('認証エラー:', error);
      return NextResponse.json(
        {
          success: false,
          error: {
            code: 'INTERNAL_ERROR',
            message: '認証処理中にエラーが発生しました',
          },
        },
        { status: 500 }
      );
    }
  };
}

/**
 * オプショナル認証ミドルウェア
 *
 * トークンがある場合のみユーザー情報を追加し、
 * ない場合でもエラーを返さずに処理を続行します
 *
 * @param handler - 認証後に実行するハンドラー関数
 * @returns Next.js API Routeハンドラー
 */
export function withOptionalAuth<T>(
  handler: (
    req: NextRequest & { user?: { id: string; email?: string; role?: string } },
    context: T
  ) => Promise<NextResponse>
) {
  return async (req: NextRequest, context: T): Promise<NextResponse> => {
    try {
      const authHeader = req.headers.get('authorization');

      if (authHeader && authHeader.startsWith('Bearer ')) {
        const token = authHeader.replace('Bearer ', '');

        const {
          data: { user },
        } = await supabaseAdmin.auth.getUser(token);

        if (user) {
          (req as AuthenticatedRequest).user = {
            id: user.id,
            email: user.email,
            role: user.role,
          };
        }
      }

      return await handler(req, context);
    } catch (error) {
      console.error('オプショナル認証エラー:', error);
      // エラーが発生してもリクエストを続行
      return await handler(req, context);
    }
  };
}

/**
 * ロールベース認証ミドルウェア
 *
 * 特定のロールを持つユーザーのみアクセスを許可します
 *
 * @param allowedRoles - 許可するロールの配列
 * @param handler - 認証後に実行するハンドラー関数
 * @returns Next.js API Routeハンドラー
 */
export function withRoleAuth<T>(
  allowedRoles: string[],
  handler: (req: AuthenticatedRequest, context: T) => Promise<NextResponse>
) {
  return withSupabaseAuth<T>(async (req, context) => {
    const userRole = req.user.role || 'user';

    if (!allowedRoles.includes(userRole)) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: 'FORBIDDEN',
            message: 'このリソースへのアクセス権限がありません',
          },
        },
        { status: 403 }
      );
    }

    return await handler(req, context);
  });
}

/**
 * ユーザーIDによる認証チェック
 *
 * リクエストパラメータのuserIdと認証されたユーザーIDが一致するかチェックします
 *
 * @param req - 認証済みリクエスト
 * @param targetUserId - 対象のユーザーID
 * @returns 認証成功の場合true
 */
export function isOwner(req: AuthenticatedRequest, targetUserId: string): boolean {
  return req.user.id === targetUserId;
}

/**
 * 管理者権限チェック
 *
 * @param req - 認証済みリクエスト
 * @returns 管理者の場合true
 */
export function isAdmin(req: AuthenticatedRequest): boolean {
  return req.user.role === 'admin';
}
