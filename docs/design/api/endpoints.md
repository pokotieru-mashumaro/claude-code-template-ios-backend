# REST API エンドポイント

> このファイルはREST APIの全エンドポイントを定義します。

---

## API設計原則

1. **RESTful設計**
   - リソース指向のURL設計
   - 適切なHTTPメソッドの使用
   - ステートレスな設計

2. **命名規則**
   - URL: kebab-case（小文字+ハイフン）
   - エンドポイント: 複数形のリソース名を使用
   - 例: `/api/users`, `/api/posts`

3. **認証**
   - JWT（Access Token + Refresh Token）
   - Bearerトークンを使用
   - ヘッダー: `Authorization: Bearer <token>`

4. **エラーハンドリング**
   - 適切なHTTPステータスコードの使用
   - エラーレスポンスは統一フォーマット

---

## 共通レスポンスフォーマット

### 成功レスポンス

```json
{
  "success": true,
  "data": { ... }
}
```

### エラーレスポンス

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "エラーメッセージ"
  }
}
```

---

## 認証系API

### POST /api/auth/register

**説明**: 新規ユーザー登録

**リクエストボディ**:
```json
{
  "email": "user@example.com",
  "password": "password123",
  "name": "ユーザー名"
}
```

**レスポンス** (201 Created):
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "name": "ユーザー名"
    },
    "accessToken": "jwt-token",
    "refreshToken": "refresh-token"
  }
}
```

**エラー**:
- 400: バリデーションエラー
- 409: メールアドレス重複

---

### POST /api/auth/login

**説明**: ログイン

**リクエストボディ**:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**レスポンス** (200 OK):
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "name": "ユーザー名"
    },
    "accessToken": "jwt-token",
    "refreshToken": "refresh-token"
  }
}
```

**エラー**:
- 401: 認証情報が不正

---

### POST /api/auth/refresh

**説明**: アクセストークン更新

**リクエストボディ**:
```json
{
  "refreshToken": "refresh-token"
}
```

**レスポンス** (200 OK):
```json
{
  "success": true,
  "data": {
    "accessToken": "new-jwt-token"
  }
}
```

**エラー**:
- 401: リフレッシュトークンが無効

---

## ユーザー系API

### GET /api/users/me

**説明**: 自分のプロフィール取得

**認証**: 必須

**レスポンス** (200 OK):
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "ユーザー名",
    "createdAt": "2025-01-01T00:00:00.000Z"
  }
}
```

---

### PUT /api/users/me

**説明**: プロフィール更新

**認証**: 必須

**リクエストボディ**:
```json
{
  "name": "新しいユーザー名"
}
```

**レスポンス** (200 OK):
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "新しいユーザー名",
    "updatedAt": "2025-01-01T00:00:00.000Z"
  }
}
```

---

### GET /api/users/:id

**説明**: 指定ユーザーのプロフィール取得

**認証**: 必須

**パスパラメータ**:
- `id`: ユーザーID

**レスポンス** (200 OK):
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "name": "ユーザー名",
    "createdAt": "2025-01-01T00:00:00.000Z"
  }
}
```

**エラー**:
- 404: ユーザーが見つからない

---

## [その他のリソース]

### GET /api/[resource]

[エンドポイントの説明]

### POST /api/[resource]

[エンドポイントの説明]

### PUT /api/[resource]/:id

[エンドポイントの説明]

### DELETE /api/[resource]/:id

[エンドポイントの説明]

---

## HTTPステータスコード一覧

| コード | 意味 | 使用例 |
|-------|------|--------|
| 200 | OK | 成功 |
| 201 | Created | リソース作成成功 |
| 400 | Bad Request | バリデーションエラー |
| 401 | Unauthorized | 認証エラー |
| 403 | Forbidden | 権限エラー |
| 404 | Not Found | リソースが見つからない |
| 409 | Conflict | リソースの重複 |
| 500 | Internal Server Error | サーバーエラー |

---

## エラーコード一覧

| コード | 説明 |
|--------|------|
| VALIDATION_ERROR | バリデーションエラー |
| UNAUTHORIZED | 認証エラー |
| FORBIDDEN | 権限エラー |
| NOT_FOUND | リソースが見つからない |
| ALREADY_EXISTS | リソースが既に存在する |
| INTERNAL_ERROR | サーバー内部エラー |

---

**最終更新日**: [日付]
