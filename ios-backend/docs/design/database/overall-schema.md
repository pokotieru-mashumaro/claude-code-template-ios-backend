# データベース設計

> このファイルはデータベース全体の設計を記載します。

---

## 使用技術

- **DBMS**: PostgreSQL
- **ORM**: Prisma
- **iOS ローカルDB**: SwiftData

---

## データベース設計原則

1. **バックエンドが真実の情報源**
   - バックエンドDBが唯一の正となるデータソース
   - iOSのSwiftDataはキャッシュとして使用

2. **命名規則**
   - テーブル名: PascalCase（単数形）例: `User`, `Post`
   - カラム名: camelCase 例: `createdAt`, `userId`
   - 外部キー: `[参照先モデル名]Id` 例: `userId`, `postId`

3. **共通フィールド**
   - `id`: 主キー（UUID）
   - `createdAt`: 作成日時
   - `updatedAt`: 更新日時

---

## ER図

```
[ここにER図を記述]

例:
User ||--o{ Post : creates
User ||--o{ Comment : writes
Post ||--o{ Comment : has
```

---

## Prismaスキーマ

```prisma
// backend/prisma/schema.prisma

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// ========================================
// User モデル
// ========================================
model User {
  id        String   @id @default(uuid())
  email     String   @unique
  password  String
  name      String
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  // リレーション
  posts     Post[]
  comments  Comment[]

  @@map("users")
}

// ========================================
// Post モデル
// ========================================
model Post {
  id        String   @id @default(uuid())
  title     String
  content   String
  userId    String
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  // リレーション
  user      User      @relation(fields: [userId], references: [id], onDelete: Cascade)
  comments  Comment[]

  @@map("posts")
}

// ========================================
// Comment モデル
// ========================================
model Comment {
  id        String   @id @default(uuid())
  content   String
  userId    String
  postId    String
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  // リレーション
  user User @relation(fields: [userId], references: [id], onDelete: Cascade)
  post Post @relation(fields: [postId], references: [id], onDelete: Cascade)

  @@map("comments")
}
```

---

## テーブル詳細

### User テーブル

**用途**: ユーザー情報を管理

| カラム名 | 型 | 必須 | 説明 |
|---------|-----|------|------|
| id | String (UUID) | ✓ | 主キー |
| email | String | ✓ | メールアドレス（ユニーク） |
| password | String | ✓ | ハッシュ化されたパスワード |
| name | String | ✓ | ユーザー名 |
| createdAt | DateTime | ✓ | 作成日時 |
| updatedAt | DateTime | ✓ | 更新日時 |

**インデックス**:
- `email`: ユニークインデックス

**リレーション**:
- `posts`: 1対多（User → Post）
- `comments`: 1対多（User → Comment）

---

### Post テーブル

**用途**: 投稿を管理

| カラム名 | 型 | 必須 | 説明 |
|---------|-----|------|------|
| id | String (UUID) | ✓ | 主キー |
| title | String | ✓ | タイトル |
| content | String | ✓ | 本文 |
| userId | String | ✓ | 作成者ID（外部キー） |
| createdAt | DateTime | ✓ | 作成日時 |
| updatedAt | DateTime | ✓ | 更新日時 |

**インデックス**:
- `userId`: 外部キーインデックス

**リレーション**:
- `user`: 多対1（Post → User）
- `comments`: 1対多（Post → Comment）

---

## iOS SwiftDataモデル

```swift
// ios/[ProjectName]/Domain/Entities/User.swift

import SwiftData
import Foundation

@Model
final class User {
  @Attribute(.unique) var id: String
  var email: String
  var name: String
  var createdAt: Date
  var updatedAt: Date

  init(id: String, email: String, name: String, createdAt: Date, updatedAt: Date) {
    self.id = id
    self.email = email
    self.name = name
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}
```

---

## マイグレーション

### 初回マイグレーション

```bash
cd backend
npx prisma migrate dev --name init
```

### スキーマ変更時

```bash
# 開発環境
npx prisma migrate dev --name [変更内容]

# 本番環境
npx prisma migrate deploy
```

---

## 型同期チェックリスト

スキーマ変更時は以下を必ず確認：

- [ ] `backend/prisma/schema.prisma` を更新
- [ ] `npx prisma migrate dev` または `npx prisma db push` 実行
- [ ] `backend/types/index.ts` の型定義を更新
- [ ] iOS の `Domain/Entities/` 配下のモデルを更新
- [ ] この設計書を更新

---

**最終更新日**: [日付]
