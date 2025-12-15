import { createClient } from '@supabase/supabase-js';

// Service Role Key を使用した管理者用クライアント
// 注意: Server-side でのみ使用すること
export function createAdminClient() {
  return createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!,
    {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    }
  );
}
