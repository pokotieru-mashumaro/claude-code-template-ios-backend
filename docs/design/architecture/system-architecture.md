# システムアーキテクチャ

> このファイルはシステム全体のアーキテクチャを定義します。

---

## アーキテクチャ方針

このプロジェクトは**ハイブリッドアーキテクチャ**を採用しています。

### データアクセスパターン

#### 1. 直接Supabaseアクセス（推奨：シンプルなCRUD）
```
┌─────────────┐
│   iOS App   │
│  (SwiftUI)  │
└──────┬──────┘
       │ HTTPS / WSS
       ▼
┌─────────────────────┐
│     Supabase        │
│  (PostgreSQL + RLS) │
│  (Auth, Storage)    │
└─────────────────────┘
```

**適用ケース**:
- ユーザープロフィール取得・更新
- 投稿の作成・一覧取得
- リアルタイム機能（チャット等）

**メリット**: 低レイテンシ、低コスト、シンプル

---

#### 2. Backend経由アクセス（推奨：複雑な処理）
```
┌─────────────┐
│   iOS App   │
│  (SwiftUI)  │
└──────┬──────┘
       │ HTTPS
       ▼
┌──────────────────────┐
│  Next.js Backend     │
│  (API Routes)        │
└──────┬───────────────┘
       │
       ▼
┌─────────────────────┐       ┌──────────────┐
│     Supabase        │       │ 外部API      │
│  (PostgreSQL + RLS) │◄─────►│ (Stripe等)   │
│  (Auth, Storage)    │       └──────────────┘
└─────────────────────┘
```

**適用ケース**:
- 外部API連携（Stripe決済、OpenAI、SendGrid）
- 複雑なビジネスロジック（ポイント計算、レコメンデーション）
- 管理者機能（Service Role Keyを使用してRLSをバイパス）
- 機密データの加工

**メリット**: セキュア、ロジック集約、外部API連携容易

---

#### 3. ハイブリッド（このプロジェクトの推奨✨）
```
┌─────────────┐
│   iOS App   │
│  (SwiftUI)  │
└──┬──────┬───┘
   │      │
   │      └────────────────────┐
   │ 単純なCRUD               │ 複雑な処理
   │                          │
   ▼                          ▼
┌─────────────────────┐  ┌──────────────────────┐
│     Supabase        │  │  Next.js Backend     │
│  (直接アクセス)      │  │  (API Routes)        │
└─────────────────────┘  └──────┬───────────────┘
                                │
                                ▼
                         ┌─────────────────────┐
                         │     Supabase        │
                         │  + 外部API統合      │
                         └─────────────────────┘
```

**実装例**:
- ✅ ユーザープロフィール取得: **iOS → Supabase（直接）**
- ✅ 投稿CRUD: **iOS → Supabase（直接）**
- ✅ リアルタイムチャット: **iOS → Supabase（直接）**
- ✅ プレミアム課金: **iOS → Next.js → Stripe + Supabase**
- ✅ AIレコメンデーション: **iOS → Next.js → OpenAI + Supabase**

---

## 全体構成（ハイブリッド）

```
┌─────────────┐
│   iOS App   │
│  (SwiftUI)  │
└──┬──────┬───┘
   │      │
   │      └──────────────────┐
   │                         │
   │ Supabase Swift SDK      │ URLSession
   │                         │
   ▼                         ▼
┌─────────────────────┐  ┌──────────────────────┐
│     Supabase        │  │  Next.js Backend     │
│                     │  │  (API Routes)        │
│  - PostgreSQL       │  └──────┬───────────────┘
│  - Auth (JWT)       │         │ Prisma ORM
│  - Storage          │         │ Service Role Key
│  - Realtime         │         │
│  - Row Level        │         ▼
│    Security (RLS)   │  ┌─────────────────────┐
└─────────────────────┘  │     Supabase        │
                         │  (RLSバイパス可能)   │
                         └──────┬──────────────┘
                                │
                                ├─► 外部API (Stripe)
                                ├─► 外部API (OpenAI)
                                └─► 外部API (SendGrid)
```

---

## 技術スタック

### iOS
- **言語**: Swift
- **UI**: SwiftUI
- **アーキテクチャ**: Clean Architecture
- **BaaS**: Supabase (Auth, Database, Storage, Realtime)
- **ローカルDB**: SwiftData（オフライン対応時）
- **ネットワーク**: Supabase Swift SDK / URLSession
- **依存性管理**: Swift Package Manager

### Backend（オプショナル）
- **フレームワーク**: Next.js 14+ (App Router)
- **言語**: TypeScript
- **BaaS**: Supabase
- **ORM**: Prisma
- **認証**: Supabase Auth (JWT自動管理)
- **WebSocket**: Supabase Realtime
- **バリデーション**: Zod

### Supabase (BaaS)
- **データベース**: PostgreSQL
- **認証**: Supabase Auth (JWT)
- **ストレージ**: Supabase Storage
- **リアルタイム**: Supabase Realtime (WebSocket)
- **セキュリティ**: Row Level Security (RLS)
- **エッジ関数**: Supabase Edge Functions（オプション）

### インフラ
- **BaaS**: Supabase
- **Backend**: Vercel / AWS
- **監視**: Sentry / Supabase Dashboard

---

## iOS アーキテクチャ (Clean Architecture)

```
┌──────────────────────────────────────┐
│        Presentation Layer            │
│  (Views, ViewModels, Coordinators)   │
└──────────────┬───────────────────────┘
               │
┌──────────────▼───────────────────────┐
│         Domain Layer                 │
│  (Entities, Use Cases, Protocols)    │
└──────────────┬───────────────────────┘
               │
┌──────────────▼───────────────────────┐
│          Data Layer                  │
│  (Repositories, API, Local Storage)  │
└──────────────────────────────────────┘
```

### ディレクトリ構成

```
ios/[ProjectName]/
├── App/
│   ├── [ProjectName]App.swift
│   └── AppDelegate.swift
├── Presentation/
│   ├── Views/
│   ├── ViewModels/
│   └── Coordinators/
├── Domain/
│   ├── Entities/
│   ├── UseCases/
│   └── Protocols/
├── Data/
│   ├── Repositories/
│   ├── Network/
│   └── Local/
└── Core/
    ├── Extensions/
    └── Utilities/
```

---

## Backend アーキテクチャ

```
┌──────────────────────────────────────┐
│         API Routes Layer             │
│    (Request/Response Handling)       │
└──────────────┬───────────────────────┘
               │
┌──────────────▼───────────────────────┐
│      Business Logic Layer            │
│      (Services, Use Cases)           │
└──────────────┬───────────────────────┘
               │
┌──────────────▼───────────────────────┐
│       Data Access Layer              │
│    (Prisma, External APIs)           │
└──────────────────────────────────────┘
```

### ディレクトリ構成

```
backend/
├── app/
│   └── api/
│       ├── auth/
│       ├── users/
│       └── [other-resources]/
├── lib/
│   ├── services/
│   ├── auth/
│   └── utils/
├── prisma/
│   ├── schema.prisma
│   └── migrations/
├── types/
│   └── index.ts
└── middleware/
    ├── auth.ts
    └── error-handler.ts
```

---

## データフロー

### iOS → Backend

1. **Presentation Layer**: ユーザーアクション
2. **ViewModel**: Use Caseを呼び出し
3. **Use Case**: Repository経由でAPIリクエスト
4. **Repository**: NetworkServiceを使用
5. **NetworkService**: HTTP/WebSocketリクエスト
6. **Backend API**: リクエスト受信
7. **Backend Service**: ビジネスロジック実行
8. **Prisma**: データベースアクセス

### Backend → iOS

1. **Prisma**: データ取得
2. **Backend Service**: データ加工
3. **API Route**: レスポンス返却
4. **iOS Repository**: レスポンス受信
5. **iOS Use Case**: Entityに変換
6. **ViewModel**: UIの状態を更新
7. **View**: UIを再描画

---

## 認証フロー

```
┌─────┐                ┌─────────┐
│ iOS │                │ Backend │
└──┬──┘                └────┬────┘
   │                        │
   │  POST /auth/login      │
   ├───────────────────────►│
   │                        │
   │  { accessToken,        │
   │    refreshToken }      │
   │◄───────────────────────┤
   │                        │
   │  Authorization:        │
   │  Bearer <accessToken>  │
   ├───────────────────────►│
   │                        │
   │  Token expired         │
   │◄───────────────────────┤
   │                        │
   │  POST /auth/refresh    │
   │  { refreshToken }      │
   ├───────────────────────►│
   │                        │
   │  { accessToken }       │
   │◄───────────────────────┤
```

**Access Token**: 15分
**Refresh Token**: 30日

---

## キャッシュ戦略

### iOS (SwiftData)
- ユーザープロフィール
- 設定情報
- 最近の取得データ

**更新タイミング**:
- アプリ起動時
- Pull to Refresh
- データ変更時

### Backend (Redis)
- セッション情報
- レート制限カウンター
- 頻繁にアクセスされるデータ

---

## セキュリティ

### 通信
- HTTPS/WSS必須
- Certificate Pinning（本番環境推奨）

### 認証
- JWT（HS256 / RS256）
- Refresh Token Rotation
- トークンの安全な保存（iOS: Keychain）

### データ
- パスワードはbcryptでハッシュ化
- 機密情報の暗号化
- SQLインジェクション対策（Prismaで自動）

### API
- レート制限
- CORS設定
- 入力値のバリデーション

---

## パフォーマンス最適化

### iOS
- 画像の遅延読み込み
- ページネーション
- キャッシュの活用

### Backend
- N+1問題の回避
- データベースインデックス
- CDNの活用
- レスポンスの圧縮

---

## 監視・ログ

### iOS
- Crashlytics / Sentry
- Analytics

### Backend
- エラーログ（Sentry）
- アクセスログ
- パフォーマンスモニタリング
- データベースクエリログ

---

**最終更新日**: [日付]
