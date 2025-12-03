# システムアーキテクチャ

> このファイルはシステム全体のアーキテクチャを定義します。

---

## 全体構成

```
┌─────────────┐
│   iOS App   │
│  (SwiftUI)  │
└──────┬──────┘
       │ HTTPS / WSS
       │
┌──────▼─────────────────┐
│   Next.js Backend      │
│   (API Routes)         │
└──────┬─────────────────┘
       │
       ├─► PostgreSQL (Prisma)
       ├─► Redis (セッション)
       ├─► AWS S3 (画像)
       └─► [その他のサービス]
```

---

## 技術スタック

### iOS
- **言語**: Swift
- **UI**: SwiftUI
- **アーキテクチャ**: Clean Architecture
- **ローカルDB**: SwiftData
- **ネットワーク**: URLSession
- **依存性管理**: Swift Package Manager

### Backend
- **フレームワーク**: Next.js 14+ (App Router)
- **言語**: TypeScript
- **ORM**: Prisma
- **認証**: JWT (Access Token + Refresh Token)
- **WebSocket**: Socket.io / ws
- **バリデーション**: Zod

### Database
- **メインDB**: PostgreSQL
- **キャッシュ**: Redis
- **ストレージ**: AWS S3 / Cloudflare R2

### インフラ
- **ホスティング**: Vercel / AWS
- **画像配信**: CloudFront / Cloudflare CDN
- **監視**: Sentry / CloudWatch

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
