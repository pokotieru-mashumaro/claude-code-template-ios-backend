import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;
const supabaseServiceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY!;

// クライアントサイド用（Anon Key）
export const supabaseClient = createClient(supabaseUrl, supabaseAnonKey);

// サーバーサイド用（Service Role Key - 管理者権限）
export const supabaseAdmin = createClient(supabaseUrl, supabaseServiceRoleKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false,
  },
});

// 型定義
export type SupabaseClient = typeof supabaseClient;
export type SupabaseAdmin = typeof supabaseAdmin;
