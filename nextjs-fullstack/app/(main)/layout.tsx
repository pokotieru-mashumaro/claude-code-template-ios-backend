interface MainLayoutProps {
  children: React.ReactNode;
}

export default function MainLayout({ children }: MainLayoutProps) {
  return (
    <div className="min-h-screen bg-white">
      {/* TODO: ヘッダーナビゲーションを追加 */}
      <main className="container mx-auto px-4 py-8">
        {children}
      </main>
    </div>
  );
}
