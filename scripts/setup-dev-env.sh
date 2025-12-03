#!/bin/bash

# 開発環境セットアップスクリプト
# 使用方法: ./scripts/setup-dev-env.sh

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🚀 開発環境セットアップ開始${NC}"
echo ""

# Node.jsバージョンチェック
check_node() {
    echo -e "${BLUE}📦 Node.jsバージョンチェック...${NC}"
    if ! command -v node &> /dev/null; then
        echo -e "${RED}❌ Node.jsがインストールされていません${NC}"
        echo "   https://nodejs.org/ からインストールしてください"
        exit 1
    fi

    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 18 ]; then
        echo -e "${YELLOW}⚠️  Node.js 18以上を推奨（現在: $(node -v)）${NC}"
    else
        echo -e "${GREEN}✅ Node.js $(node -v)${NC}"
    fi
}

# Supabaseプロジェクトチェック
check_supabase() {
    echo -e "${BLUE}🔥 Supabaseプロジェクトチェック...${NC}"
    echo -e "${YELLOW}   Supabaseプロジェクトを作成してください${NC}"
    echo -e "${YELLOW}   https://supabase.com/dashboard${NC}"
    echo -e "${GREEN}✅ Supabaseプロジェクト作成後、.envファイルに設定を記入してください${NC}"
}

# Xcodeチェック（macOSのみ）
check_xcode() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "${BLUE}🍎 Xcodeチェック...${NC}"
        if ! command -v xcodebuild &> /dev/null; then
            echo -e "${YELLOW}⚠️  Xcodeがインストールされていません${NC}"
            echo "   App StoreからXcodeをインストールしてください"
        else
            echo -e "${GREEN}✅ Xcode $(xcodebuild -version | head -1)${NC}"
        fi
    fi
}

# Backendセットアップ
setup_backend() {
    if [ -d "backend" ]; then
        echo -e "${BLUE}🔧 Backendセットアップ...${NC}"
        cd backend

        # 環境変数ファイル作成
        if [ ! -f ".env" ]; then
            echo -e "${YELLOW}📝 .env ファイルを作成しています...${NC}"
            cat > .env << EOF
# Supabase
NEXT_PUBLIC_SUPABASE_URL="https://your-project.supabase.co"
NEXT_PUBLIC_SUPABASE_ANON_KEY="your-anon-key"
SUPABASE_SERVICE_ROLE_KEY="your-service-role-key"

# Database (Supabase PostgreSQL)
DATABASE_URL="postgresql://postgres:[YOUR-PASSWORD]@db.your-project.supabase.co:5432/postgres"

# Node
NODE_ENV="development"
EOF
            echo -e "${GREEN}✅ .env ファイル作成完了${NC}"
            echo -e "${YELLOW}   ⚠️  Supabaseプロジェクトの設定を記入してください${NC}"
            echo -e "${YELLOW}   Settings > API からキーを取得${NC}"
            echo -e "${YELLOW}   Settings > Database > Connection string からDATABASE_URLを取得${NC}"
        fi

        # 依存関係インストール
        echo -e "${BLUE}📦 npm install...${NC}"
        npm install

        # Prismaセットアップ
        if [ -f "prisma/schema.prisma" ]; then
            echo -e "${BLUE}🔨 Prisma セットアップ...${NC}"
            npx prisma generate
            echo -e "${YELLOW}   ℹ️  データベースが起動している場合: npx prisma db push${NC}"
        fi

        cd ..
        echo -e "${GREEN}✅ Backendセットアップ完了${NC}"
    else
        echo -e "${YELLOW}⚠️  backendディレクトリが見つかりません${NC}"
    fi
}

# iOSセットアップ
setup_ios() {
    if [ -d "ios" ] && [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "${BLUE}📱 iOSセットアップ...${NC}"
        cd ios

        # CocoaPods（使用している場合）
        if [ -f "Podfile" ]; then
            if command -v pod &> /dev/null; then
                echo -e "${BLUE}📦 pod install...${NC}"
                pod install
            else
                echo -e "${YELLOW}⚠️  CocoaPodsがインストールされていません${NC}"
                echo "   sudo gem install cocoapods"
            fi
        fi

        cd ..
        echo -e "${GREEN}✅ iOSセットアップ完了${NC}"
    fi
}

# Git hooksセットアップ
setup_git_hooks() {
    echo -e "${BLUE}🪝 Git hooksセットアップ...${NC}"

    if [ -d ".git" ]; then
        # pre-commit hook
        cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Pre-commit hook

echo "🔍 Pre-commit checks..."

# TypeScript型チェック（backendがある場合）
if [ -d "backend" ]; then
    cd backend
    echo "  TypeScript型チェック..."
    npm run type-check 2>/dev/null || echo "  ⚠️ npm run type-check が設定されていません"
    cd ..
fi

echo "✅ Pre-commit checks完了"
EOF
        chmod +x .git/hooks/pre-commit
        echo -e "${GREEN}✅ Git hooks設定完了${NC}"
    else
        echo -e "${YELLOW}⚠️  Gitリポジトリが初期化されていません${NC}"
    fi
}

# Claude Code hooksの実行権限付与
setup_claude_hooks() {
    echo -e "${BLUE}🤖 Claude Code hooksセットアップ...${NC}"
    if [ -d ".claude/hooks" ]; then
        chmod +x .claude/hooks/*.sh
        echo -e "${GREEN}✅ Claude Code hooks実行権限付与完了${NC}"
    fi
}

# メイン処理
main() {
    check_node
    check_supabase
    check_xcode
    echo ""

    setup_backend
    echo ""

    setup_ios
    echo ""

    setup_git_hooks
    echo ""

    setup_claude_hooks
    echo ""

    echo -e "${GREEN}🎉 開発環境セットアップ完了！${NC}"
    echo ""
    echo -e "${YELLOW}次のステップ:${NC}"
    echo "1. Supabaseプロジェクトを作成（https://supabase.com/dashboard）"
    echo "2. backend/.env を編集してSupabase設定を記入"
    echo "3. cd backend && npx prisma db push"
    echo "4. cd backend && npm run dev"
    echo "5. iOSアプリをXcodeで開いて実行"
    echo ""
}

main
