# コーディング規約

> このファイルはプロジェクト全体のコーディング規約を定義します。

---

## 共通ルール

### NEVER（絶対禁止）
- ❌ `any`型は絶対に使用禁止（Swift/TypeScript共通）
- ❌ console.log / printをコミットに含めない（デバッグ用途のみ）
- ❌ 未使用の変数・import
- ❌ ハードコードされた機密情報

### MUST（必須事項）
- ✅ コミットメッセージは日本語で記述
- ✅ 型安全性を保つ
- ✅ 関数の前後に空行を入れる
- ✅ 行末の余分なスペースは削除

---

## Swift (iOS)

### インデント
- **2スペース**（タブは使用禁止）

### 命名規則

#### 変数・関数
- **camelCase**
```swift
let userName = "John"
func fetchUserProfile() { }
```

#### クラス・構造体・プロトコル・Enum
- **PascalCase**
```swift
class UserViewModel { }
struct UserProfile { }
protocol UserRepositoryProtocol { }
enum UserStatus { }
```

#### 定数
- **SCREAMING_SNAKE_CASE**
```swift
let MAX_RETRY_COUNT = 3
let API_BASE_URL = "https://api.example.com"
```

### ファイル名
- **PascalCase.swift**
```
UserViewModel.swift
LoginView.swift
NetworkService.swift
```

### 型注釈
- `any`型は絶対に使用禁止
```swift
// ❌ NG
var data: any = someValue

// ✅ OK
var data: UserProfile = someValue
```

### 文字列
- ダブルクォート優先
```swift
let message = "Hello, World!"
```

### アクセス修飾子
- 明示的に指定
```swift
public class PublicClass { }
internal func internalFunc() { }
private var privateVar: String = ""
```

### オプショナル
- 適切にアンラップ
```swift
// ✅ OK: guard let
guard let user = optionalUser else { return }

// ✅ OK: if let
if let user = optionalUser {
  // ...
}

// ❌ NG: 強制アンラップは避ける
let user = optionalUser!
```

### エラーハンドリング
- do-catch を使用
```swift
do {
  let data = try await fetchData()
} catch {
  print("Error: \(error)")
}
```

### SwiftUI
- ViewBuilderを活用
```swift
var body: some View {
  VStack {
    Text("Hello")
    Button("Tap me") { }
  }
}
```

---

## TypeScript (Backend)

### インデント
- **2スペース**（タブは使用禁止）

### 命名規則

#### 変数・関数
- **camelCase**
```typescript
const userName = 'John';
function fetchUserProfile() { }
```

#### クラス・型・インターフェース
- **PascalCase**
```typescript
class UserService { }
type UserProfile = { }
interface UserRepository { }
```

#### 定数
- **SCREAMING_SNAKE_CASE**
```typescript
const MAX_RETRY_COUNT = 3;
const API_BASE_URL = 'https://api.example.com';
```

### ファイル名
- **kebab-case.ts**
```
user-service.ts
auth-middleware.ts
api-client.ts
```

### 型安全性
- `any`型は絶対に使用禁止
```typescript
// ❌ NG
const data: any = someValue;

// ✅ OK
const data: UserProfile = someValue;

// ✅ OK: 型が不明な場合はunknown
const data: unknown = someValue;
```

### 文字列
- シングルクォート優先
```typescript
const message = 'Hello, World!';
```

### セミコロン
- 必須
```typescript
const userName = 'John';
const userAge = 30;
```

### Import
- グループ分けして整理
```typescript
// 1. 外部ライブラリ
import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';

// 2. 内部モジュール
import { UserService } from '@/lib/services/user-service';
import { AuthMiddleware } from '@/middleware/auth';

// 3. 型定義
import type { UserProfile } from '@/types';
```

### 関数
- async/await を優先
```typescript
// ✅ OK
async function fetchUser(id: string): Promise<User> {
  const user = await prisma.user.findUnique({ where: { id } });
  return user;
}

// ❌ NG: Promiseチェーンは避ける
function fetchUser(id: string): Promise<User> {
  return prisma.user.findUnique({ where: { id } })
    .then(user => user);
}
```

### エラーハンドリング
- try-catch を使用
```typescript
try {
  const data = await fetchData();
} catch (error) {
  console.error('Error:', error);
  throw error;
}
```

### null / undefined
- 明示的にチェック
```typescript
if (user === null || user === undefined) {
  throw new Error('User not found');
}

// または
if (!user) {
  throw new Error('User not found');
}
```

---

## Git コミットメッセージ

### フォーマット
```
<type>: <subject>

<body>
```

### Type
- `feat`: 新機能追加
- `fix`: バグ修正
- `refactor`: リファクタリング
- `docs`: ドキュメント更新
- `test`: テスト追加・修正
- `chore`: その他の変更
- `perf`: パフォーマンス改善

### 例
```
feat: ユーザー登録機能を追加

- ユーザー登録フォームの実装
- バリデーション処理
- メール確認機能
```

### ルール
- ✅ 日本語で記述（必須）
- ✅ subjectは簡潔に（50文字以内推奨）
- ✅ bodyには詳細を記述
- ❌ "fix typo" のような意味のないコミットは避ける

---

## コメント

### Swift
```swift
// 単一行コメント

/// ドキュメンテーションコメント
/// - Parameter user: ユーザー情報
/// - Returns: ユーザープロフィール
func getUserProfile(user: User) -> UserProfile {
  // ...
}
```

### TypeScript
```typescript
// 単一行コメント

/**
 * ユーザープロフィールを取得
 * @param userId ユーザーID
 * @returns ユーザープロフィール
 */
async function getUserProfile(userId: string): Promise<UserProfile> {
  // ...
}
```

### ルール
- ✅ 複雑なロジックには説明を追加
- ✅ TODOコメントは明確に
- ❌ 不要なコメントは削除

---

## フォーマッター

### Swift
- SwiftFormat または Xcode内蔵フォーマッター

### TypeScript
- Prettier
```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 80
}
```

---

## リンター

### Swift
- SwiftLint

### TypeScript
- ESLint
```json
{
  "extends": ["next/core-web-vitals", "prettier"],
  "rules": {
    "no-console": "warn",
    "@typescript-eslint/no-explicit-any": "error",
    "@typescript-eslint/no-unused-vars": "error"
  }
}
```

---

## テスト

### 命名規則
```swift
// Swift
func testLoginSuccess() { }
func testLoginFailureWithInvalidPassword() { }
```

```typescript
// TypeScript
describe('UserService', () => {
  it('should return user profile', async () => { });
  it('should throw error when user not found', async () => { });
});
```

### カバレッジ目標
- **ユニットテスト**: 70%以上
- **重要な機能**: E2Eテスト必須

---

**最終更新日**: [日付]
