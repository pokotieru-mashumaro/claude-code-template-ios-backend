import { AuthError, PostgrestError } from '@supabase/supabase-js';

/**
 * Supabaseエラーハンドリングユーティリティ
 */

export interface ErrorResponse {
  success: false;
  error: {
    code: string;
    message: string;
    details?: unknown;
  };
}

/**
 * Supabase AuthError をアプリケーションエラーに変換
 */
export function handleAuthError(error: AuthError): ErrorResponse {
  // Supabase Auth特有のエラーコードをマッピング
  const errorMap: Record<string, { code: string; message: string }> = {
    'invalid_credentials': {
      code: 'INVALID_CREDENTIALS',
      message: 'メールアドレスまたはパスワードが正しくありません',
    },
    'email_not_confirmed': {
      code: 'EMAIL_NOT_CONFIRMED',
      message: 'メールアドレスが確認されていません',
    },
    'user_already_exists': {
      code: 'USER_ALREADY_EXISTS',
      message: 'このメールアドレスは既に登録されています',
    },
    'weak_password': {
      code: 'WEAK_PASSWORD',
      message: 'パスワードが弱すぎます。8文字以上を推奨します',
    },
    'over_email_send_rate_limit': {
      code: 'RATE_LIMIT_EXCEEDED',
      message: 'メール送信回数の上限に達しました。しばらくしてから再試行してください',
    },
    'session_not_found': {
      code: 'SESSION_NOT_FOUND',
      message: 'セッションが見つかりません。再度ログインしてください',
    },
    'refresh_token_not_found': {
      code: 'REFRESH_TOKEN_NOT_FOUND',
      message: 'リフレッシュトークンが見つかりません',
    },
  };

  const mappedError = errorMap[error.code || ''] || {
    code: 'AUTH_ERROR',
    message: error.message || '認証エラーが発生しました',
  };

  return {
    success: false,
    error: {
      ...mappedError,
      details: error,
    },
  };
}

/**
 * Supabase PostgrestError をアプリケーションエラーに変換
 */
export function handlePostgrestError(error: PostgrestError): ErrorResponse {
  // PostgreSQL エラーコードをマッピング
  // https://www.postgresql.org/docs/current/errcodes-appendix.html
  const errorCodeMap: Record<string, { code: string; message: string }> = {
    '23505': {
      code: 'DUPLICATE_KEY',
      message: '既に存在するデータです',
    },
    '23503': {
      code: 'FOREIGN_KEY_VIOLATION',
      message: '関連するデータが見つかりません',
    },
    '23502': {
      code: 'NOT_NULL_VIOLATION',
      message: '必須項目が入力されていません',
    },
    '42P01': {
      code: 'UNDEFINED_TABLE',
      message: 'テーブルが見つかりません',
    },
    '42703': {
      code: 'UNDEFINED_COLUMN',
      message: 'カラムが見つかりません',
    },
    'PGRST116': {
      code: 'NOT_FOUND',
      message: 'データが見つかりません',
    },
    'PGRST301': {
      code: 'RLS_POLICY_VIOLATION',
      message: 'アクセス権限がありません',
    },
  };

  const mappedError = errorCodeMap[error.code] || {
    code: 'DATABASE_ERROR',
    message: error.message || 'データベースエラーが発生しました',
  };

  return {
    success: false,
    error: {
      ...mappedError,
      details: error,
    },
  };
}

/**
 * 汎用エラーハンドラ
 */
export function handleSupabaseError(error: unknown): ErrorResponse {
  // AuthError
  if (error && typeof error === 'object' && 'status' in error && 'code' in error) {
    const authError = error as AuthError;
    return handleAuthError(authError);
  }

  // PostgrestError
  if (error && typeof error === 'object' && 'code' in error && 'message' in error) {
    const postgrestError = error as PostgrestError;
    return handlePostgrestError(postgrestError);
  }

  // 通常のError
  if (error instanceof Error) {
    return {
      success: false,
      error: {
        code: 'INTERNAL_ERROR',
        message: error.message || 'サーバーエラーが発生しました',
        details: error,
      },
    };
  }

  // Unknown error
  return {
    success: false,
    error: {
      code: 'UNKNOWN_ERROR',
      message: '不明なエラーが発生しました',
      details: error,
    },
  };
}

/**
 * エラーレスポンス作成ヘルパー
 */
export function createErrorResponse(
  code: string,
  message: string,
  details?: unknown
): ErrorResponse {
  return {
    success: false,
    error: {
      code,
      message,
      details,
    },
  };
}

/**
 * バリデーションエラー
 */
export function createValidationError(
  message: string,
  details?: unknown
): ErrorResponse {
  return createErrorResponse('VALIDATION_ERROR', message, details);
}

/**
 * 認証エラー
 */
export function createUnauthorizedError(
  message = '認証が必要です'
): ErrorResponse {
  return createErrorResponse('UNAUTHORIZED', message);
}

/**
 * 権限エラー
 */
export function createForbiddenError(
  message = 'この操作を実行する権限がありません'
): ErrorResponse {
  return createErrorResponse('FORBIDDEN', message);
}

/**
 * Not Foundエラー
 */
export function createNotFoundError(
  resource = 'リソース'
): ErrorResponse {
  return createErrorResponse('NOT_FOUND', `${resource}が見つかりません`);
}

/**
 * エラーログ出力
 */
export function logSupabaseError(error: unknown, context?: string): void {
  const prefix = context ? `[${context}]` : '';

  if (error && typeof error === 'object') {
    console.error(`${prefix} Supabase Error:`, JSON.stringify(error, null, 2));
  } else {
    console.error(`${prefix} Error:`, error);
  }
}
