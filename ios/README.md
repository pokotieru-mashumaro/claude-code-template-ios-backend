# iOS App (SwiftUI + Supabase + Clean Architecture)

このディレクトリには、SwiftUIとSupabase、Clean Architectureを使用したiOSアプリが含まれています。

## アーキテクチャ

Clean Architectureの3層構造を採用：

```
ios/App/
├── Presentation/        # UI層
│   ├── Views/          # SwiftUI Views
│   └── ViewModels/     # ViewModels (MVVM)
├── Domain/             # ビジネスロジック層
│   ├── Entities/       # エンティティ（モデル）
│   ├── UseCases/       # ユースケース
│   └── Repositories/   # Repository Protocol
└── Data/               # データ層
    ├── Repositories/   # Repository実装
    ├── DataSources/    # DataSource (Supabase/Local)
    └── Models/         # API Response Models
```

## 依存関係の方向

```
Presentation → Domain ← Data
```

- **Presentation層**: ViewとViewModelを含む。Domainに依存。
- **Domain層**: エンティティとビジネスロジックを含む。他の層に依存しない。
- **Data層**: Supabase、DB等のデータ取得を担当。Domainに依存。

## セットアップ

### 1. Swift Packageプロジェクト作成

```bash
# Xcodeプロジェクトをセットアップ
./scripts/setup-ios-project.sh MyApp

# Xcodeで開く
open ios/
```

### 2. Supabase設定

`Config.xcconfig` または Info.plist に追加：

```xml
<key>SUPABASE_URL</key>
<string>https://your-project.supabase.co</string>
<key>SUPABASE_ANON_KEY</key>
<string>your-anon-key</string>
```

## コーディング規約

- インデント: 2スペース
- 命名: camelCase (変数・関数), PascalCase (クラス・構造体)
- `any`型禁止
- ファイル名: PascalCase.swift

詳細は `docs/project-management/coding-standards.md` を参照。

## データフロー

1. **View** → ユーザーアクションをViewModelに通知
2. **ViewModel** → UseCaseまたはRepositoryを呼び出し
3. **Repository** → DataSourceからデータ取得
4. **DataSource** → NetworkServiceでAPI通信
5. **NetworkService** → BackendのAPIエンドポイントにリクエスト
6. レスポンスを逆順で返却し、Viewに反映

## Supabase統合

### SupabaseClient初期化

```swift
import Supabase

let supabase = SupabaseClient(
  supabaseURL: URL(string: "https://your-project.supabase.co")!,
  supabaseKey: "your-anon-key"
)
```

### 認証

```swift
// サインアップ
try await supabase.auth.signUp(email: email, password: password)

// ログイン
try await supabase.auth.signIn(email: email, password: password)

// サインアウト
try await supabase.auth.signOut()

// 現在のセッション取得
let session = try await supabase.auth.session
```

### データベースクエリ

```swift
// ユーザー一覧取得
let users: [User] = try await supabase
  .from("users")
  .select()
  .execute()
  .value

// 作成
let newUser = User(id: UUID().uuidString, email: "test@example.com", name: "Test")
try await supabase
  .from("users")
  .insert(newUser)
  .execute()

// 更新
try await supabase
  .from("users")
  .update(["name": "新しい名前"])
  .eq("id", userId)
  .execute()

// 削除
try await supabase
  .from("users")
  .delete()
  .eq("id", userId)
  .execute()
```

### リアルタイム購読

```swift
let channel = await supabase.channel("public:users")

await channel.on(
  .postgresChanges(
    event: .all,
    schema: "public",
    table: "users"
  ),
  filter: nil
) { payload in
  print("データ変更: \(payload)")
}

await channel.subscribe()
```

## ネットワーク層（Next.js API用）

Supabaseを使わない独自APIエンドポイントを呼ぶ場合:

### NetworkService

`Data/DataSources/NetworkService.swift`

- URLSessionを使用したHTTP通信
- async/awaitサポート
- エラーハンドリング
- APIレスポンスのデコード

### 使用例

```swift
let networkService = NetworkService.shared

let users: [User] = try await networkService.request(
  endpoint: "/api/users",
  method: .get
)
```

## 状態管理

### ViewState

```swift
enum ViewState<T> {
  case idle       // 初期状態
  case loading    // 読み込み中
  case loaded(T)  // データ取得成功
  case error(Error) // エラー発生
}
```

ViewModelで`@Published var state: ViewState<T>`として使用。

## テスト

```bash
# Xcodeでテスト実行
⌘ + U
```

または

```bash
xcodebuild test -scheme [スキーム名] -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 環境変数

### Supabase設定

Info.plist または Config.xcconfig で設定：

```xml
<key>SUPABASE_URL</key>
<string>$(SUPABASE_URL)</string>
<key>SUPABASE_ANON_KEY</key>
<string>$(SUPABASE_ANON_KEY)</string>
```

Xcodeスキームの環境変数として設定：
- `SUPABASE_URL`: `https://your-project.supabase.co`
- `SUPABASE_ANON_KEY`: `your-anon-key`

### Backend API（Next.js）のベースURL

`NetworkService.swift` 内で設定：

```swift
private init() {
  self.baseURL = "http://localhost:3000"  // 開発環境
  // self.baseURL = "https://your-backend.vercel.app"  // 本番環境
}
```

本番環境では環境変数やビルド設定から取得するように変更してください。
