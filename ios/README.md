# iOS App (SwiftUI + Clean Architecture)

このディレクトリには、SwiftUIとClean Architectureを使用したiOSアプリが含まれています。

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
    ├── DataSources/    # DataSource (Remote/Local)
    └── Models/         # API Response Models
```

## 依存関係の方向

```
Presentation → Domain ← Data
```

- **Presentation層**: ViewとViewModelを含む。Domainに依存。
- **Domain層**: エンティティとビジネスロジックを含む。他の層に依存しない。
- **Data層**: ネットワーク、DB等のデータ取得を担当。Domainに依存。

## セットアップ

```bash
# Xcodeでプロジェクトを開く
open ios/[プロジェクト名].xcodeproj

# または
cd ios
xed .
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

## ネットワーク層

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

Backend APIのベースURLは `NetworkService.swift` 内で設定：

```swift
private init() {
  self.baseURL = "http://localhost:3000"  // 開発環境
  // self.baseURL = "https://api.example.com"  // 本番環境
}
```

本番環境では環境変数やビルド設定から取得するように変更してください。
