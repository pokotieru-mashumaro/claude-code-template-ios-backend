# ディレクトリ構成

## 概要

Next.js App Router を使用したディレクトリ構成です。

---

## 構成

```
nextjs-fullstack/
├── .claude/                      # Claude Code設定
│   ├── CLAUDE.md                 # プロジェクト設定
│   ├── hooks/                    # 自動チェックスクリプト
│   └── skills/                   # スキル設定
│
├── .github/                      # GitHub設定
│   └── workflows/                # CI/CD
│
├── app/                          # Next.js App Router
│   ├── api/                      # API Routes
│   │   └── [endpoint]/
│   │       └── route.ts
│   ├── (auth)/                   # 認証ページグループ
│   │   ├── login/
│   │   ├── register/
│   │   └── layout.tsx
│   ├── (main)/                   # メインページグループ
│   │   ├── dashboard/
│   │   └── layout.tsx
│   ├── globals.css               # グローバルCSS
│   ├── layout.tsx                # ルートレイアウト
│   └── page.tsx                  # ホームページ
│
├── components/                   # UIコンポーネント
│   ├── ui/                       # 基本UIコンポーネント
│   │   ├── button.tsx
│   │   ├── input.tsx
│   │   └── ...
│   └── features/                 # 機能別コンポーネント
│       └── [feature]/
│
├── lib/                          # ユーティリティ
│   ├── supabase/                 # Supabaseクライアント
│   │   ├── client.ts             # ブラウザ用
│   │   ├── server.ts             # サーバー用
│   │   └── admin.ts              # 管理者用
│   ├── db/                       # データベース
│   │   └── prisma.ts             # Prismaクライアント
│   └── utils/                    # 汎用ユーティリティ
│
├── prisma/                       # Prisma設定
│   ├── schema.prisma             # スキーマ定義
│   ├── seed.ts                   # シードデータ
│   └── migrations/               # マイグレーション
│
├── types/                        # 型定義
│   └── index.ts
│
├── docs/                         # ドキュメント
│   ├── requirements/             # 要件定義
│   ├── design/                   # 技術設計
│   ├── setup/                    # セットアップ
│   └── project-management/       # プロジェクト管理
│
├── scripts/                      # 自動化スクリプト
│
├── templates/                    # コードテンプレート
│
├── public/                       # 静的ファイル
│
├── package.json
├── tsconfig.json
├── tailwind.config.js
├── next.config.js
└── .gitignore
```

---

## 命名規則

| 種類 | 規則 | 例 |
|------|------|-----|
| ディレクトリ | kebab-case | `user-profile/` |
| TypeScriptファイル | kebab-case | `user-service.ts` |
| Reactコンポーネント | PascalCase | `UserCard.tsx` |
| CSS/スタイル | kebab-case | `button.module.css` |

---

**最終更新日**: [日付]
