# WebSocket API仕様

> このファイルはWebSocket APIの仕様を定義します。
> リアルタイム通信が不要な場合は、このファイルは削除してください。

---

## 概要

リアルタイム通信が必要な機能で使用します。

**使用例**:
- チャット機能
- 通知のリアルタイム配信
- オンライン状態の同期

---

## 接続

### エンドポイント

```
wss://[your-domain]/ws
```

### 認証

接続時にクエリパラメータでトークンを渡す:

```
wss://[your-domain]/ws?token=<access-token>
```

### 接続確立

**クライアント → サーバー**:
```json
{
  "type": "connect",
  "data": {
    "userId": "uuid"
  }
}
```

**サーバー → クライアント**:
```json
{
  "type": "connected",
  "data": {
    "connectionId": "connection-id",
    "timestamp": "2025-01-01T00:00:00.000Z"
  }
}
```

---

## メッセージフォーマット

### 基本フォーマット

```json
{
  "type": "message-type",
  "data": { ... }
}
```

---

## チャット機能（例）

### メッセージ送信

**クライアント → サーバー**:
```json
{
  "type": "chat:send",
  "data": {
    "recipientId": "uuid",
    "message": "メッセージ本文"
  }
}
```

**サーバー → 受信者**:
```json
{
  "type": "chat:message",
  "data": {
    "id": "message-id",
    "senderId": "uuid",
    "senderName": "送信者名",
    "message": "メッセージ本文",
    "timestamp": "2025-01-01T00:00:00.000Z"
  }
}
```

### 既読通知

**クライアント → サーバー**:
```json
{
  "type": "chat:read",
  "data": {
    "messageId": "message-id"
  }
}
```

**サーバー → 送信者**:
```json
{
  "type": "chat:read-receipt",
  "data": {
    "messageId": "message-id",
    "readBy": "uuid",
    "readAt": "2025-01-01T00:00:00.000Z"
  }
}
```

---

## 通知機能（例）

### 通知受信

**サーバー → クライアント**:
```json
{
  "type": "notification",
  "data": {
    "id": "notification-id",
    "type": "match" | "message" | "system",
    "title": "通知タイトル",
    "body": "通知本文",
    "timestamp": "2025-01-01T00:00:00.000Z"
  }
}
```

---

## オンライン状態（例）

### オンライン状態の送信

**クライアント → サーバー**:
```json
{
  "type": "presence:update",
  "data": {
    "status": "online" | "away" | "offline"
  }
}
```

### オンライン状態の受信

**サーバー → 関連ユーザー**:
```json
{
  "type": "presence:status",
  "data": {
    "userId": "uuid",
    "status": "online" | "away" | "offline",
    "timestamp": "2025-01-01T00:00:00.000Z"
  }
}
```

---

## エラーハンドリング

### エラーメッセージ

**サーバー → クライアント**:
```json
{
  "type": "error",
  "data": {
    "code": "ERROR_CODE",
    "message": "エラーメッセージ"
  }
}
```

### エラーコード

| コード | 説明 |
|--------|------|
| UNAUTHORIZED | 認証エラー |
| INVALID_MESSAGE | メッセージフォーマットが不正 |
| RECIPIENT_NOT_FOUND | 受信者が見つからない |
| CONNECTION_ERROR | 接続エラー |

---

## Ping/Pong

**クライアント → サーバー**:
```json
{
  "type": "ping"
}
```

**サーバー → クライアント**:
```json
{
  "type": "pong",
  "data": {
    "timestamp": "2025-01-01T00:00:00.000Z"
  }
}
```

---

## 切断

### 通常の切断

**クライアント → サーバー**:
```json
{
  "type": "disconnect"
}
```

### 強制切断

サーバーから切断される場合:
```json
{
  "type": "disconnected",
  "data": {
    "reason": "切断理由"
  }
}
```

---

**最終更新日**: [日付]
