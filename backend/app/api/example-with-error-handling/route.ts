import { NextRequest, NextResponse } from 'next/server';
import { supabaseClient } from '@/lib/auth/supabase';
import { handleSupabaseError, createValidationError, createNotFoundError } from '@/lib/errors/supabase-errors';

/**
 * Supabaseエラーハンドリングの使用例
 * GET /api/example-with-error-handling?userId=xxx
 */
export async function GET(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url);
    const userId = searchParams.get('userId');

    // バリデーション
    if (!userId) {
      return NextResponse.json(
        createValidationError('userIdは必須です'),
        { status: 400 }
      );
    }

    // Supabaseクエリ
    const { data, error } = await supabaseClient
      .from('users')
      .select('*')
      .eq('id', userId)
      .single();

    // エラーハンドリング
    if (error) {
      const errorResponse = handleSupabaseError(error);
      return NextResponse.json(errorResponse, { status: 500 });
    }

    // データが見つからない場合
    if (!data) {
      return NextResponse.json(
        createNotFoundError('ユーザー'),
        { status: 404 }
      );
    }

    // 成功レスポンス
    return NextResponse.json({
      success: true,
      data,
    });
  } catch (error) {
    // 予期しないエラー
    const errorResponse = handleSupabaseError(error);
    return NextResponse.json(errorResponse, { status: 500 });
  }
}

/**
 * POST /api/example-with-error-handling
 */
export async function POST(req: NextRequest) {
  try {
    const body = await req.json();

    // バリデーション
    if (!body.email) {
      return NextResponse.json(
        createValidationError('emailは必須です'),
        { status: 400 }
      );
    }

    // Supabaseクエリ
    const { data, error } = await supabaseClient
      .from('users')
      .insert(body)
      .select()
      .single();

    if (error) {
      const errorResponse = handleSupabaseError(error);

      // 重複エラーの場合は409 Conflict
      if (errorResponse.error.code === 'DUPLICATE_KEY') {
        return NextResponse.json(errorResponse, { status: 409 });
      }

      return NextResponse.json(errorResponse, { status: 500 });
    }

    return NextResponse.json(
      {
        success: true,
        data,
      },
      { status: 201 }
    );
  } catch (error) {
    const errorResponse = handleSupabaseError(error);
    return NextResponse.json(errorResponse, { status: 500 });
  }
}
