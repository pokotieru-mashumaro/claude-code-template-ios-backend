# ディレクトリ構成

## 概要

React Native (Expo) + Next.js Backend のディレクトリ構成です。

---

## 構成

```
reactnative-backend/
├── .claude/                      # Claude Code設定
│   ├── CLAUDE.md                 # プロジェクト設定
│   ├── hooks/                    # 自動チェックスクリプト
│   └── skills/                   # スキル設定
│
├── .github/                      # GitHub設定
│   └── workflows/                # CI/CD
│
├── backend/                      # Next.js Backend
│   ├── app/                      # App Router
│   │   ├── api/                  # API Routes
│   │   ├── layout.tsx
│   │   └── page.tsx
│   ├── lib/                      # ユーティリティ
│   │   ├── auth/                 # 認証関連
│   │   ├── db/                   # データベース
│   │   └── errors/               # エラーハンドリング
│   ├── middleware/               # ミドルウェア
│   ├── prisma/                   # Prisma設定
│   │   ├── schema.prisma
│   │   └── seed.ts
│   ├── types/                    # 型定義
│   └── package.json
│
├── mobile/                       # React Native (Expo)
│   ├── app/                      # Expo Router
│   │   ├── _layout.tsx           # ルートレイアウト
│   │   ├── index.tsx             # ホーム
│   │   ├── (tabs)/               # タブナビゲーション
│   │   └── (auth)/               # 認証画面
│   ├── components/               # UIコンポーネント
│   │   ├── Button.tsx
│   │   └── Input.tsx
│   ├── lib/                      # ユーティリティ
│   │   ├── supabase.ts           # Supabaseクライアント
│   │   └── api.ts                # API呼び出し
│   ├── hooks/                    # カスタムフック
│   │   └── useAuth.ts
│   ├── assets/                   # 静的アセット
│   ├── app.json                  # Expo設定
│   └── package.json
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
└── .gitignore
```

---

## 命名規則

| 種類 | 規則 | 例 |
|------|------|-----|
| ディレクトリ | kebab-case | `user-profile/` |
| TypeScriptファイル | kebab-case | `user-service.ts` |
| Reactコンポーネント | PascalCase | `UserCard.tsx` |

---

**最終更新日**: [日付]
