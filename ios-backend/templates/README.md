# Templates

このディレクトリには、コード自動生成用のテンプレートファイルが含まれています。

---

## 📝 利用可能なテンプレート

### Backend

#### api-route.template.ts

**用途**: Next.js API Routeのテンプレート

**含まれる機能**:
- GET（一覧取得、ページネーション対応）
- POST（作成、Zodバリデーション）
- エラーハンドリング
- レスポンスフォーマット統一

**プレースホルダー**:
- `{{RESOURCE_NAME}}`: リソース名（PascalCase）例: `User`
- `{{RESOURCE_LOWER}}`: リソース名（camelCase）例: `user`
- `{{RESOURCE_KEBAB}}`: リソース名（kebab-case）例: `user-profile`

**使用例**:
```bash
# generate-feature.sh が自動的に使用
./scripts/generate-feature.sh Post api
```

---

### iOS

#### swift-view.template.swift

**用途**: SwiftUI Viewのテンプレート

**含まれる機能**:
- Loading/Error/Empty状態の表示
- List表示
- Pull to Refresh
- NavigationView

**プレースホルダー**:
- `{{FEATURE_NAME}}`: 機能名（PascalCase）例: `User`

**使用例**:
```bash
# 手動でコピーして使用
cp templates/swift-view.template.swift ios/YourApp/Presentation/Views/User/UserView.swift
# {{FEATURE_NAME}} を実際の名前に置換
```

---

#### swift-viewmodel.template.swift

**用途**: ViewModelのテンプレート（MVVM）

**含まれる機能**:
- State管理（idle, loading, loaded, error）
- Repository連携
- Combine対応

**プレースホルダー**:
- `{{FEATURE_NAME}}`: 機能名（PascalCase）例: `User`

**使用例**:
```bash
cp templates/swift-viewmodel.template.swift ios/YourApp/Presentation/ViewModels/User/UserViewModel.swift
```

---

## 🔧 テンプレートのカスタマイズ

プロジェクト固有のテンプレートを追加できます。

### 新しいテンプレートの追加例

#### 1. テンプレートファイル作成

```bash
# Backend Service層のテンプレート
cat > templates/service.template.ts << 'EOF'
export class {{RESOURCE_NAME}}Service {
  async getAll() {
    // TODO: 実装
  }

  async getById(id: string) {
    // TODO: 実装
  }

  async create(data: Create{{RESOURCE_NAME}}DTO) {
    // TODO: 実装
  }
}
EOF
```

#### 2. generate-feature.sh に生成ロジック追加

```bash
generate_service() {
    echo -e "${GREEN}🔧 Service生成中...${NC}"

    mkdir -p "backend/lib/services"

    sed -e "s/{{RESOURCE_NAME}}/${FEATURE_NAME}/g" \
        templates/service.template.ts > \
        "backend/lib/services/${FEATURE_KEBAB}-service.ts"

    echo -e "${GREEN}✅ Service生成完了${NC}"
}
```

---

## 📋 テンプレート設計原則

### 1. プレースホルダーの命名規則

| プレースホルダー | 形式 | 例 |
|----------------|------|-----|
| `{{RESOURCE_NAME}}` | PascalCase | `User`, `BlogPost` |
| `{{RESOURCE_LOWER}}` | camelCase | `user`, `blogPost` |
| `{{RESOURCE_KEBAB}}` | kebab-case | `user`, `blog-post` |
| `{{FEATURE_NAME}}` | PascalCase | `User`, `BlogPost` |

### 2. 必須要素

全てのテンプレートに含めるべき要素:
- ✅ エラーハンドリング
- ✅ 型安全性（`any`型禁止）
- ✅ コメント（TODO含む）
- ✅ 一貫したコーディングスタイル

### 3. TODOコメント

自動生成後にカスタマイズが必要な箇所には`TODO`コメントを記載:

```typescript
// TODO: バリデーション追加
// TODO: 認証ミドルウェア追加
```

---

## 🎯 テンプレート使用フロー

### 自動生成（推奨）

```bash
# generate-feature.sh を使用
./scripts/generate-feature.sh User crud
```

### 手動コピー

```bash
# 1. テンプレートをコピー
cp templates/api-route.template.ts backend/app/api/users/route.ts

# 2. プレースホルダーを置換
# {{RESOURCE_NAME}} → User
# {{RESOURCE_LOWER}} → user
# {{RESOURCE_KEBAB}} → user

# または sedコマンドで一括置換
sed -i '' 's/{{RESOURCE_NAME}}/User/g' backend/app/api/users/route.ts
sed -i '' 's/{{RESOURCE_LOWER}}/user/g' backend/app/api/users/route.ts
sed -i '' 's/{{RESOURCE_KEBAB}}/user/g' backend/app/api/users/route.ts
```

---

## 💡 ベストプラクティス

### 1. テンプレートは最小限に保つ

- 共通部分のみをテンプレート化
- プロジェクト固有のロジックは含めない
- 拡張性を考慮した設計

### 2. 定期的な更新

- プロジェクトの成長に合わせてテンプレートを更新
- ベストプラクティスを反映
- チーム内で合意したパターンを統一

### 3. ドキュメント化

- 新しいテンプレートを追加したら、このREADMEを更新
- 使用例を記載
- プレースホルダーの説明を追加

---

**最終更新日**: 2025-12-03
