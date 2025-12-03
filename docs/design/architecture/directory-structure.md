# ディレクトリ構成

> このファイルはプロジェクト全体のディレクトリ構造を定義します。

---

## プロジェクト全体

```
project-root/
├── ios/                      # iOSアプリ
├── backend/                  # Next.jsバックエンド
├── docs/                     # ドキュメント
├── .claude/                  # Claude Code設定
├── .gitignore
└── README.md
```

---

## iOS ディレクトリ構成

```
ios/
└── [ProjectName]/
    ├── App/
    │   ├── [ProjectName]App.swift         # アプリエントリーポイント
    │   └── AppDelegate.swift              # AppDelegate
    │
    ├── Presentation/
    │   ├── Views/
    │   │   ├── Auth/
    │   │   │   ├── LoginView.swift
    │   │   │   └── RegisterView.swift
    │   │   ├── Home/
    │   │   │   └── HomeView.swift
    │   │   └── Profile/
    │   │       └── ProfileView.swift
    │   │
    │   ├── ViewModels/
    │   │   ├── Auth/
    │   │   │   ├── LoginViewModel.swift
    │   │   │   └── RegisterViewModel.swift
    │   │   ├── Home/
    │   │   │   └── HomeViewModel.swift
    │   │   └── Profile/
    │   │       └── ProfileViewModel.swift
    │   │
    │   └── Components/                    # 共通UIコンポーネント
    │       ├── Button/
    │       ├── TextField/
    │       └── Card/
    │
    ├── Domain/
    │   ├── Entities/                      # ドメインモデル
    │   │   ├── User.swift
    │   │   └── Post.swift
    │   │
    │   ├── UseCases/                      # ビジネスロジック
    │   │   ├── Auth/
    │   │   │   ├── LoginUseCase.swift
    │   │   │   └── RegisterUseCase.swift
    │   │   └── User/
    │   │       └── GetUserProfileUseCase.swift
    │   │
    │   └── Protocols/                     # インターフェース定義
    │       ├── Repositories/
    │       │   ├── AuthRepositoryProtocol.swift
    │       │   └── UserRepositoryProtocol.swift
    │       └── Services/
    │           └── NetworkServiceProtocol.swift
    │
    ├── Data/
    │   ├── Repositories/                  # Repository実装
    │   │   ├── AuthRepository.swift
    │   │   └── UserRepository.swift
    │   │
    │   ├── Network/
    │   │   ├── NetworkService.swift       # ネットワーク層
    │   │   ├── APIClient.swift
    │   │   ├── APIEndpoint.swift
    │   │   └── WebSocketClient.swift
    │   │
    │   ├── Local/                         # ローカルストレージ
    │   │   ├── SwiftDataManager.swift
    │   │   └── KeychainManager.swift
    │   │
    │   └── DTOs/                          # データ転送オブジェクト
    │       ├── Auth/
    │       │   ├── LoginRequestDTO.swift
    │       │   └── LoginResponseDTO.swift
    │       └── User/
    │           └── UserProfileDTO.swift
    │
    ├── Core/
    │   ├── Extensions/                    # 拡張機能
    │   │   ├── String+Extensions.swift
    │   │   ├── Date+Extensions.swift
    │   │   └── View+Extensions.swift
    │   │
    │   ├── Utilities/                     # ユーティリティ
    │   │   ├── Logger.swift
    │   │   ├── Validator.swift
    │   │   └── Constants.swift
    │   │
    │   └── DependencyInjection/          # DI
    │       └── DIContainer.swift
    │
    ├── Resources/
    │   ├── Assets.xcassets/              # アセット
    │   ├── Localizable.strings           # ローカライゼーション
    │   └── Info.plist
    │
    └── [ProjectName].xcodeproj/
```

---

## Backend ディレクトリ構成

```
backend/
├── app/
│   ├── api/
│   │   ├── auth/
│   │   │   ├── login/
│   │   │   │   └── route.ts
│   │   │   ├── register/
│   │   │   │   └── route.ts
│   │   │   └── refresh/
│   │   │       └── route.ts
│   │   │
│   │   ├── users/
│   │   │   ├── me/
│   │   │   │   └── route.ts
│   │   │   └── [id]/
│   │   │       └── route.ts
│   │   │
│   │   └── [other-resources]/
│   │
│   ├── layout.tsx
│   └── page.tsx
│
├── lib/
│   ├── services/                         # ビジネスロジック
│   │   ├── auth-service.ts
│   │   ├── user-service.ts
│   │   └── [other-service].ts
│   │
│   ├── auth/                             # 認証関連
│   │   ├── jwt.ts
│   │   └── password.ts
│   │
│   ├── db/                               # データベース
│   │   └── prisma.ts
│   │
│   ├── validators/                       # バリデーション
│   │   ├── auth-validators.ts
│   │   └── user-validators.ts
│   │
│   └── utils/                            # ユーティリティ
│       ├── logger.ts
│       ├── error-handler.ts
│       └── constants.ts
│
├── middleware/
│   ├── auth.ts                           # 認証ミドルウェア
│   ├── error-handler.ts                  # エラーハンドラー
│   └── rate-limit.ts                     # レート制限
│
├── types/
│   ├── index.ts                          # TypeScript型定義
│   ├── api.ts                            # API型定義
│   └── entities.ts                       # エンティティ型定義
│
├── prisma/
│   ├── schema.prisma                     # Prismaスキーマ
│   ├── migrations/                       # マイグレーション
│   └── seed.ts                           # シードデータ
│
├── public/                               # 静的ファイル
│
├── .env                                  # 環境変数
├── .env.example                          # 環境変数サンプル
├── .gitignore
├── next.config.js
├── package.json
├── tsconfig.json
└── README.md
```

---

## ドキュメントディレクトリ構成

```
docs/
├── requirements/                         # 要件定義
│   ├── _TEMPLATE.md                      # テンプレート
│   ├── user-profile.md
│   ├── authentication.md
│   ├── premium-features.md
│   ├── security-compliance.md
│   └── legal-compliance.md
│
├── design/                               # 技術設計
│   ├── database/
│   │   └── overall-schema.md
│   ├── api/
│   │   ├── endpoints.md
│   │   └── websocket.md
│   ├── architecture/
│   │   ├── system-architecture.md
│   │   └── directory-structure.md
│   ├── ui-ux/
│   │   ├── screen-list.md
│   │   └── screen-details.md
│   └── notification/
│       └── notification-timing.md
│
└── project-management/                  # プロジェクト管理
    ├── implementation-phases.md
    └── coding-standards.md
```

---

## .claude ディレクトリ構成

```
.claude/
├── CLAUDE.md                             # プロジェクト設定
├── settings.local.json                   # Hook設定
└── hooks/                                # Hookスクリプト
    ├── README.md
    ├── requirements-consistency-check.sh
    └── type-sync-check.sh
```

---

## 命名規則

### iOS
- **ファイル名**: PascalCase.swift
- **クラス/構造体**: PascalCase
- **変数/関数**: camelCase
- **定数**: SCREAMING_SNAKE_CASE

### Backend
- **ファイル名**: kebab-case.ts
- **クラス/型**: PascalCase
- **変数/関数**: camelCase
- **定数**: SCREAMING_SNAKE_CASE

### ドキュメント
- **ファイル名**: kebab-case.md
- **見出し**: # 日本語またはEnglish

---

**最終更新日**: [日付]
