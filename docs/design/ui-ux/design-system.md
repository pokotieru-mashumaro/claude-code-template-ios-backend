# デザインシステム

このドキュメントでは、iOS/Webアプリ全体で統一されたデザインシステムを定義します。

---

## カラーパレット

### プライマリカラー

```swift
// iOS (SwiftUI)
extension Color {
  static let primaryMain = Color(hex: "#007AFF")      // メインカラー
  static let primaryLight = Color(hex: "#5AC8FA")     // ライトカラー
  static let primaryDark = Color(hex: "#0051D5")      // ダークカラー
}
```

```css
/* Web (CSS Variables) */
:root {
  --color-primary-main: #007AFF;
  --color-primary-light: #5AC8FA;
  --color-primary-dark: #0051D5;
}
```

### セカンダリカラー

```swift
// iOS
extension Color {
  static let secondaryMain = Color(hex: "#5856D6")
  static let secondaryLight = Color(hex: "#AF52DE")
  static let secondaryDark = Color(hex: "#5856D6")
}
```

```css
/* Web */
:root {
  --color-secondary-main: #5856D6;
  --color-secondary-light: #AF52DE;
  --color-secondary-dark: #5856D6;
}
```

### グレースケール

```swift
// iOS
extension Color {
  static let gray50 = Color(hex: "#F9FAFB")
  static let gray100 = Color(hex: "#F3F4F6")
  static let gray200 = Color(hex: "#E5E7EB")
  static let gray300 = Color(hex: "#D1D5DB")
  static let gray400 = Color(hex: "#9CA3AF")
  static let gray500 = Color(hex: "#6B7280")
  static let gray600 = Color(hex: "#4B5563")
  static let gray700 = Color(hex: "#374151")
  static let gray800 = Color(hex: "#1F2937")
  static let gray900 = Color(hex: "#111827")
}
```

### セマンティックカラー

```swift
// iOS
extension Color {
  static let success = Color(hex: "#34C759")
  static let warning = Color(hex: "#FF9500")
  static let error = Color(hex: "#FF3B30")
  static let info = Color(hex: "#007AFF")
}
```

```css
/* Web */
:root {
  --color-success: #34C759;
  --color-warning: #FF9500;
  --color-error: #FF3B30;
  --color-info: #007AFF;
}
```

---

## タイポグラフィ

### フォントファミリー

- **iOS**: SF Pro (システムフォント)
- **Web**: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto

### フォントサイズ

```swift
// iOS
enum FontSize {
  static let xs: CGFloat = 12
  static let sm: CGFloat = 14
  static let base: CGFloat = 16
  static let lg: CGFloat = 18
  static let xl: CGFloat = 20
  static let xl2: CGFloat = 24
  static let xl3: CGFloat = 30
  static let xl4: CGFloat = 36
}
```

```css
/* Web */
:root {
  --font-size-xs: 0.75rem;    /* 12px */
  --font-size-sm: 0.875rem;   /* 14px */
  --font-size-base: 1rem;     /* 16px */
  --font-size-lg: 1.125rem;   /* 18px */
  --font-size-xl: 1.25rem;    /* 20px */
  --font-size-2xl: 1.5rem;    /* 24px */
  --font-size-3xl: 1.875rem;  /* 30px */
  --font-size-4xl: 2.25rem;   /* 36px */
}
```

### フォントウェイト

```swift
// iOS
enum FontWeight {
  case thin        // 100
  case light       // 300
  case regular     // 400
  case medium      // 500
  case semibold    // 600
  case bold        // 700
  case heavy       // 800
}
```

---

## スペーシング

8pxベースのスペーシングシステム

```swift
// iOS
enum Spacing {
  static let xs: CGFloat = 4    // 0.5x
  static let sm: CGFloat = 8    // 1x
  static let md: CGFloat = 16   // 2x
  static let lg: CGFloat = 24   // 3x
  static let xl: CGFloat = 32   // 4x
  static let xl2: CGFloat = 48  // 6x
  static let xl3: CGFloat = 64  // 8x
}
```

```css
/* Web */
:root {
  --spacing-xs: 0.25rem;  /* 4px */
  --spacing-sm: 0.5rem;   /* 8px */
  --spacing-md: 1rem;     /* 16px */
  --spacing-lg: 1.5rem;   /* 24px */
  --spacing-xl: 2rem;     /* 32px */
  --spacing-2xl: 3rem;    /* 48px */
  --spacing-3xl: 4rem;    /* 64px */
}
```

---

## ボーダー半径

```swift
// iOS
enum CornerRadius {
  static let none: CGFloat = 0
  static let sm: CGFloat = 4
  static let md: CGFloat = 8
  static let lg: CGFloat = 12
  static let xl: CGFloat = 16
  static let full: CGFloat = 9999
}
```

```css
/* Web */
:root {
  --radius-none: 0;
  --radius-sm: 0.25rem;   /* 4px */
  --radius-md: 0.5rem;    /* 8px */
  --radius-lg: 0.75rem;   /* 12px */
  --radius-xl: 1rem;      /* 16px */
  --radius-full: 9999px;
}
```

---

## シャドウ

```swift
// iOS
extension View {
  func cardShadow() -> some View {
    self.shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
  }

  func elevatedShadow() -> some View {
    self.shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
  }
}
```

```css
/* Web */
:root {
  --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
  --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
}
```

---

## コンポーネント

### ボタン

#### プライマリボタン

```swift
// iOS
struct PrimaryButton: View {
  let title: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.system(size: FontSize.base, weight: .semibold))
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.md)
        .background(Color.primaryMain)
        .cornerRadius(CornerRadius.md)
    }
  }
}
```

#### セカンダリボタン

```swift
// iOS
struct SecondaryButton: View {
  let title: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.system(size: FontSize.base, weight: .semibold))
        .foregroundColor(.primaryMain)
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.md)
        .background(Color.clear)
        .overlay(
          RoundedRectangle(cornerRadius: CornerRadius.md)
            .stroke(Color.primaryMain, lineWidth: 2)
        )
    }
  }
}
```

### カード

```swift
// iOS
struct Card<Content: View>: View {
  let content: Content

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    content
      .padding(Spacing.md)
      .background(Color.white)
      .cornerRadius(CornerRadius.lg)
      .cardShadow()
  }
}
```

### テキストフィールド

```swift
// iOS
struct CustomTextField: View {
  let placeholder: String
  @Binding var text: String

  var body: some View {
    TextField(placeholder, text: $text)
      .padding(Spacing.md)
      .background(Color.gray100)
      .cornerRadius(CornerRadius.md)
      .font(.system(size: FontSize.base))
  }
}
```

---

## アイコン

- **iOS**: SF Symbols
- **Web**: Heroicons, Feather Icons

### よく使うアイコン

- ホーム: `house.fill`
- 検索: `magnifyingglass`
- プロフィール: `person.circle.fill`
- 設定: `gearshape.fill`
- 通知: `bell.fill`
- いいね: `heart.fill`
- コメント: `message.fill`
- シェア: `square.and.arrow.up`

---

## アニメーション

### デフォルトアニメーション

```swift
// iOS
.animation(.easeInOut(duration: 0.3), value: state)
```

### スプリングアニメーション

```swift
// iOS
.animation(.spring(response: 0.3, dampingFraction: 0.7), value: state)
```

### カスタムアニメーション

```swift
// iOS
withAnimation(.easeOut(duration: 0.2)) {
  // state変更
}
```

---

## ダークモード対応

### カラー定義（ライト/ダーク）

```swift
// iOS
extension Color {
  static let background = Color(light: .white, dark: .black)
  static let text = Color(light: .black, dark: .white)
  static let cardBackground = Color(light: .gray100, dark: .gray800)
}

extension Color {
  init(light: Color, dark: Color) {
    self.init(uiColor: UIColor { traitCollection in
      traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
    })
  }
}
```

---

## レスポンシブデザイン（Web）

### ブレークポイント

```css
/* Webのみ */
:root {
  --breakpoint-sm: 640px;
  --breakpoint-md: 768px;
  --breakpoint-lg: 1024px;
  --breakpoint-xl: 1280px;
}

@media (min-width: 640px) {
  /* タブレット */
}

@media (min-width: 1024px) {
  /* デスクトップ */
}
```

---

**最終更新日**: 2025-12-04
