import { PrismaClient } from '@prisma/client';
import { supabaseAdmin } from '../lib/auth/supabase';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 シードデータ投入開始...');

  // Supabase Authでユーザー作成
  const { data: authUser1, error: error1 } = await supabaseAdmin.auth.admin.createUser({
    email: 'test@example.com',
    password: 'password123',
    email_confirm: true,
    user_metadata: {
      name: 'テストユーザー',
    },
  });

  if (error1) {
    console.error('❌ ユーザー1作成エラー:', error1);
  } else {
    // Prismaでユーザープロフィール作成
    const user1 = await prisma.user.upsert({
      where: { id: authUser1.user.id },
      update: {},
      create: {
        id: authUser1.user.id,
        email: 'test@example.com',
        name: 'テストユーザー',
      },
    });
    console.log('✅ ユーザー1作成完了:', user1);
  }

  const { data: authUser2, error: error2 } = await supabaseAdmin.auth.admin.createUser({
    email: 'admin@example.com',
    password: 'password123',
    email_confirm: true,
    user_metadata: {
      name: '管理者',
    },
  });

  if (error2) {
    console.error('❌ ユーザー2作成エラー:', error2);
  } else {
    const user2 = await prisma.user.upsert({
      where: { id: authUser2.user.id },
      update: {},
      create: {
        id: authUser2.user.id,
        email: 'admin@example.com',
        name: '管理者',
      },
    });
    console.log('✅ ユーザー2作成完了:', user2);
  }

  // 追加のシードデータをここに記述

  console.log('🎉 シードデータ投入完了！');
}

main()
  .catch((e) => {
    console.error('❌ シードデータ投入エラー:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
