# iOSプロジェクトセットアップガイド

このテンプレートにはSwiftのソースコードが含まれていますが、Xcodeプロジェクトファイル（`.xcodeproj`）は含まれていません。

以下の手順に従って、手動でXcodeプロジェクトを作成してください。

---

## 📱 前提条件

- **Xcode 15.0以上** がインストールされていること
- **macOS Sonoma以上** を推奨
- **CocoaPods** または **Swift Package Manager** の知識

---

## 🚀 手動セットアップ手順

### ステップ1: Xcodeで新規プロジェクトを作成

1. **Xcodeを起動**
   ```bash
   open -a Xcode
   ```

2. **"Create a new Xcode project"** を選択

3. **iOS → App** を選択して "Next"

4. プロジェクト設定:
   - **Product Name**: `YourAppName`（プロジェクト名を入力）
   - **Team**: 自分のApple Developer Team
   - **Organization Identifier**: `com.yourcompany`（逆ドメイン形式）
   - **Bundle Identifier**: 自動生成される（例: `com.yourcompany.YourAppName`）
   - **Interface**: **SwiftUI**
   - **Language**: **Swift**
   - **Storage**: **None**（後でSwiftDataを追加）
   - **Include Tests**: ✅ チェック

5. **保存場所**: `ios/` ディレクトリを選択

6. **Create** をクリック

---

### ステップ2: テンプレートのソースコードを統合

#### 2-1. 既存のファイル構成を確認

```bash
cd /path/to/your-project
tree ios/App
```

テンプレートには以下の構造があります:

```
ios/App/
├── Data/
│   ├── DataSources/
│   │   ├── SupabaseClient.swift
│   │   ├── NetworkService.swift
│   │   └── UserRemoteDataSource.swift
│   └── Repositories/
│       ├── UserRepository.swift
│       └── UserRepositoryImpl.swift
├── Domain/
│   ├── Entities/
│   │   ├── User.swift
│   │   └── PaginatedResponse.swift
│   └── Repositories/
│       └── UserRepositoryProtocol.swift
└── Presentation/
    ├── Views/
    │   └── UserListView.swift
    └── ViewModels/
        └── UserListViewModel.swift
```

#### 2-2. Xcodeプロジェクトにファイルを追加

1. **Xcodeで `YourAppName` プロジェクトを開く**
   ```bash
   open ios/YourAppName.xcodeproj
   ```

2. **既存の `App` グループを削除**（まだ何も追加していない場合）
   - Xcode左サイドバーの `YourAppName` フォルダを右クリック
   - "Delete" → "Move to Trash"（物理ファイルを削除）

3. **テンプレートの `App/` フォルダをXcodeに追加**
   - Xcode左サイドバーの `YourAppName` プロジェクトを右クリック
   - "Add Files to 'YourAppName'..."
   - `ios/App/` フォルダを選択
   - **重要**: 以下のオプションを設定
     - ✅ "Copy items if needed" にチェック
     - ✅ "Create groups" を選択
     - ✅ "Add to targets: YourAppName" にチェック
   - "Add" をクリック

4. **エントリーポイントの作成**
   - Xcode左サイドバーで `YourAppName` グループを右クリック
   - "New File..." → "Swift File"
   - ファイル名: `YourAppNameApp.swift`
   - 以下の内容を記述:

```swift
import SwiftUI

@main
struct YourAppNameApp: App {
  var body: some Scene {
    WindowGroup {
      UserListView()
    }
  }
}
```

---

### ステップ3: Supabase Swift SDKを追加

#### 3-1. Swift Package Managerで依存関係を追加

1. **Xcodeでプロジェクトを開く**

2. **File → Add Package Dependencies...**

3. **以下のURLを入力**:
   ```
   https://github.com/supabase/supabase-swift
   ```

4. **Dependency Rule**: "Up to Next Major Version" で `2.0.0` を指定

5. **Add Package** をクリック

6. **パッケージを選択**:
   - ✅ `Supabase`
   - ✅ `Auth`
   - ✅ `Realtime`
   - ✅ `Storage`
   - ✅ `PostgREST`

7. **Add Package** をクリック

#### 3-2. Supabase設定ファイルを作成

1. **Xcode左サイドバーで `YourAppName` グループを右クリック**
   - "New File..." → "Swift File"
   - ファイル名: `SupabaseConfig.swift`

2. **以下の内容を記述**:

```swift
import Foundation

enum SupabaseConfig {
  static let url = URL(string: "YOUR_SUPABASE_PROJECT_URL")!
  static let anonKey = "YOUR_SUPABASE_ANON_KEY"
}
```

3. **Supabase認証情報を入力**
   - Supabaseダッシュボード → Settings → API から取得
   - `url`: Project URL（例: `https://xxxxx.supabase.co`）
   - `anonKey`: anon/public key

**⚠️ 重要**: 本番環境では環境変数またはキーチェーンで管理してください。

---

### ステップ4: SupabaseClientの初期化を修正

既存の `ios/App/Data/DataSources/SupabaseClient.swift` を開いて、以下のように修正:

```swift
import Supabase

class SupabaseClient {
  static let shared = SupabaseClient()

  let client: SupabaseClient

  private init() {
    self.client = SupabaseClient(
      supabaseURL: SupabaseConfig.url,
      supabaseKey: SupabaseConfig.anonKey
    )
  }
}
```

---

### ステップ5: Info.plistの設定

#### 5-1. App Transport Security設定（開発環境のみ）

1. **Xcodeで `Info.plist` を開く**

2. **Key追加**: `App Transport Security Settings`
   - Type: Dictionary

3. **`App Transport Security Settings` の中に追加**:
   - Key: `Allow Arbitrary Loads`
   - Type: Boolean
   - Value: `NO`（本番はNO）

4. **Supabaseドメインの例外を追加**:
   - Key: `Exception Domains`
   - Type: Dictionary
   - その中に `xxxxx.supabase.co`（自分のSupabaseドメイン）を追加
     - Key: `xxxxx.supabase.co`
     - Type: Dictionary
       - `NSExceptionAllowsInsecureHTTPLoads`: NO
       - `NSIncludesSubdomains`: YES

---

### ステップ6: ビルドと実行

1. **Xcodeでビルド**
   ```
   Cmd + B
   ```

2. **エラーがないか確認**
   - 型エラー、インポートエラーがある場合は修正

3. **シミュレータで実行**
   ```
   Cmd + R
   ```

4. **UserListViewが表示されることを確認**

---

## 📁 最終的なディレクトリ構造

```
ios/
├── YourAppName.xcodeproj/       # Xcodeプロジェクトファイル
├── YourAppName/                 # Xcodeが作成したルート
│   ├── YourAppNameApp.swift     # エントリーポイント
│   ├── SupabaseConfig.swift     # Supabase設定
│   ├── App/                     # テンプレートのファイル
│   │   ├── Data/
│   │   ├── Domain/
│   │   └── Presentation/
│   ├── Assets.xcassets/
│   ├── Preview Content/
│   └── Info.plist
├── YourAppNameTests/            # ユニットテスト
└── YourAppNameUITests/          # UIテスト
```

---

## 🔧 追加設定（推奨）

### SwiftLintの設定

1. **SwiftLintをインストール**
   ```bash
   brew install swiftlint
   ```

2. **Xcodeビルドフェーズに追加**
   - Xcodeでプロジェクト設定を開く
   - "Build Phases" → "+" → "New Run Script Phase"
   - 以下のスクリプトを追加:
     ```bash
     if which swiftlint >/dev/null; then
       swiftlint
     else
       echo "warning: SwiftLint not installed"
     fi
     ```

3. **`.swiftlint.yml` を確認**
   - テンプレートには `ios/.swiftlint.yml` が含まれています

---

## ⚠️ トラブルシューティング

### エラー: "No such module 'Supabase'"

**原因**: Swift Package Managerの依存関係が正しく解決されていない

**解決策**:
```bash
# Xcodeを閉じる
# Derived Dataを削除
rm -rf ~/Library/Developer/Xcode/DerivedData

# Xcodeを再起動
open ios/YourAppName.xcodeproj

# File → Packages → Reset Package Caches
# File → Packages → Update to Latest Package Versions
```

---

### エラー: "Cannot find 'SupabaseClient' in scope"

**原因**: `SupabaseClient.swift` のクラス名が重複している

**解決策**:
```swift
// SupabaseClient.swift を以下のように修正
import Supabase

class AppSupabaseClient {
  static let shared = AppSupabaseClient()

  let client: Supabase.SupabaseClient  // 明示的に型を指定

  private init() {
    self.client = Supabase.SupabaseClient(
      supabaseURL: SupabaseConfig.url,
      supabaseKey: SupabaseConfig.anonKey
    )
  }
}
```

---

### ビルドが遅い

**原因**: Xcodeのインデックス作成中

**解決策**:
- 初回ビルドは時間がかかります（5-10分程度）
- `Preferences → Locations → Derived Data` でパスを確認
- SSDの空き容量を確保

---

## 📚 次のステップ

1. **認証機能の実装**: [docs/requirements/authentication.md](../requirements/authentication.md)
2. **画面追加**: `generate-feature.sh` でボイラープレート生成
3. **テストの追加**: XCTestを使用したユニットテスト

---

**最終更新日**: 2025-12-04
