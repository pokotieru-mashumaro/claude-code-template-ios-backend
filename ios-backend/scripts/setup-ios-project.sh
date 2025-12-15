#!/bin/bash

# iOS Xcodeプロジェクトセットアップスクリプト
# 使用方法: ./scripts/setup-ios-project.sh <ProjectName>

set -e

PROJECT_NAME="${1:-MyApp}"
IOS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../ios" && pwd)"

echo "🍎 iOS Xcodeプロジェクトをセットアップしています..."
echo "プロジェクト名: $PROJECT_NAME"

# Xcodeがインストールされているか確認
if ! command -v xcodebuild &> /dev/null; then
  echo "❌ エラー: Xcodeがインストールされていません"
  exit 1
fi

# Xcodeプロジェクトを作成（既存のApp/ディレクトリを使用）
cd "$IOS_DIR"

if [ -d "$PROJECT_NAME.xcodeproj" ]; then
  echo "⚠️  $PROJECT_NAME.xcodeproj は既に存在します"
  read -p "上書きしますか？ (y/N): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "キャンセルしました"
    exit 0
  fi
  rm -rf "$PROJECT_NAME.xcodeproj"
fi

# Package.swiftを作成（Swift Package Manager用）
cat > Package.swift <<EOF
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "$PROJECT_NAME",
  platforms: [
    .iOS(.v17)
  ],
  products: [
    .library(
      name: "$PROJECT_NAME",
      targets: ["$PROJECT_NAME"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/supabase-community/supabase-swift.git", from: "2.0.0"),
  ],
  targets: [
    .target(
      name: "$PROJECT_NAME",
      dependencies: [
        .product(name: "Supabase", package: "supabase-swift"),
      ],
      path: "App"
    ),
    .testTarget(
      name: "${PROJECT_NAME}Tests",
      dependencies: ["$PROJECT_NAME"]
    ),
  ]
)
EOF

echo "✅ Package.swift を作成しました"

# .swiftpm/xcode/xcshareddata/xcschemes ディレクトリを作成
mkdir -p .swiftpm/xcode/xcshareddata/xcschemes

echo ""
echo "✅ iOS プロジェクトのセットアップが完了しました！"
echo ""
echo "次のステップ:"
echo "1. Xcodeで ios/ ディレクトリを開く:"
echo "   open $IOS_DIR"
echo ""
echo "2. または、ターミナルからビルド:"
echo "   cd ios && swift build"
echo ""
echo "注意: 実際のiOSアプリとして実行するには、Xcodeで"
echo "「File > New > Project」から新しいiOSアプリプロジェクトを作成し、"
echo "このPackageをローカルパッケージとして追加してください。"
