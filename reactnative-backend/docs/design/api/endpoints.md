# API エンドポイント設計

## 概要

Next.js API Routes を使用したREST API設計です。

---

## 共通仕様

### ベースURL
- 開発環境: `http://localhost:3000/api`
- 本番環境: `https://[domain]/api`

### 認証
- Supabase Auth による JWT認証
- Authorization ヘッダーに Bearer トークンを含める

### レスポンス形式

#### 成功時
```json
{
  "data": { ... }
}
```

#### エラー時
```json
{
  "error": {
    "message": "エラーメッセージ",
    "code": "ERROR_CODE"
  }
}
```

---

## エンドポイント一覧

### ヘルスチェック

| メソッド | パス | 説明 | 認証 |
|---------|------|------|------|
| GET | /api/health | ヘルスチェック | 不要 |

---

## TODO: エンドポイントを追加

---

**最終更新日**: [日付]
