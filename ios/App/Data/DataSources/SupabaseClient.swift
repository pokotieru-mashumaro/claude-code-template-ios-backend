import Foundation
import Supabase

/// Supabaseクライアントのシングルトン
/// 認証、データベース、ストレージへのアクセスを提供
final class SupabaseClientManager {
  static let shared = SupabaseClientManager()

  let client: SupabaseClient

  private init() {
    guard let supabaseURL = URL(string: Configuration.supabaseURL) else {
      fatalError("Invalid Supabase URL")
    }

    self.client = SupabaseClient(
      supabaseURL: supabaseURL,
      supabaseKey: Configuration.supabaseAnonKey
    )
  }

  // MARK: - 認証

  /// サインアップ
  func signUp(email: String, password: String) async throws -> User {
    let response = try await client.auth.signUp(
      email: email,
      password: password
    )

    guard let user = response.user else {
      throw SupabaseError.authenticationFailed
    }

    return User(
      id: user.id.uuidString,
      email: user.email ?? "",
      name: user.email ?? "",
      createdAt: user.createdAt,
      updatedAt: user.updatedAt
    )
  }

  /// ログイン
  func signIn(email: String, password: String) async throws -> User {
    let session = try await client.auth.signIn(
      email: email,
      password: password
    )

    return User(
      id: session.user.id.uuidString,
      email: session.user.email ?? "",
      name: session.user.email ?? "",
      createdAt: session.user.createdAt,
      updatedAt: session.user.updatedAt
    )
  }

  /// ログアウト
  func signOut() async throws {
    try await client.auth.signOut()
  }

  /// 現在のセッション取得
  func getCurrentSession() async throws -> Session {
    return try await client.auth.session
  }

  /// 現在のユーザー取得
  func getCurrentUser() async throws -> User? {
    guard let authUser = try await client.auth.session.user else {
      return nil
    }

    return User(
      id: authUser.id.uuidString,
      email: authUser.email ?? "",
      name: authUser.email ?? "",
      createdAt: authUser.createdAt,
      updatedAt: authUser.updatedAt
    )
  }

  // MARK: - データベース

  /// ユーザー一覧取得
  func fetchUsers() async throws -> [User] {
    let response: [User] = try await client
      .from("users")
      .select()
      .execute()
      .value

    return response
  }

  /// ユーザー詳細取得
  func fetchUser(id: String) async throws -> User? {
    let response: [User] = try await client
      .from("users")
      .select()
      .eq("id", value: id)
      .execute()
      .value

    return response.first
  }

  /// ユーザー作成
  func createUser(_ user: User) async throws -> User {
    let response: User = try await client
      .from("users")
      .insert(user)
      .select()
      .single()
      .execute()
      .value

    return response
  }

  /// ユーザー更新
  func updateUser(id: String, name: String) async throws -> User {
    let response: User = try await client
      .from("users")
      .update(["name": name])
      .eq("id", value: id)
      .select()
      .single()
      .execute()
      .value

    return response
  }

  /// ユーザー削除
  func deleteUser(id: String) async throws {
    try await client
      .from("users")
      .delete()
      .eq("id", value: id)
      .execute()
  }

  // MARK: - リアルタイム購読

  /// ユーザーテーブルの変更を購読
  func subscribeToUsers(
    onChange: @escaping (User) -> Void
  ) async throws -> RealtimeChannel {
    let channel = await client.channel("public:users")

    await channel.on(
      .postgresChanges(
        event: .all,
        schema: "public",
        table: "users"
      ),
      filter: nil
    ) { payload in
      if let user = try? JSONDecoder().decode(User.self, from: JSONEncoder().encode(payload.record)) {
        onChange(user)
      }
    }

    await channel.subscribe()
    return channel
  }

  /// チャンネルの購読解除
  func unsubscribe(from channel: RealtimeChannel) async {
    await client.removeChannel(channel)
  }
}

// MARK: - Configuration

private struct Configuration {
  static var supabaseURL: String {
    // 優先順位: 環境変数 > Info.plist > デフォルト
    if let envURL = ProcessInfo.processInfo.environment["SUPABASE_URL"] {
      return envURL
    }

    if let plistURL = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String {
      return plistURL
    }

    fatalError("SUPABASE_URL not found in environment or Info.plist")
  }

  static var supabaseAnonKey: String {
    if let envKey = ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"] {
      return envKey
    }

    if let plistKey = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String {
      return plistKey
    }

    fatalError("SUPABASE_ANON_KEY not found in environment or Info.plist")
  }
}

// MARK: - Errors

enum SupabaseError: Error, LocalizedError {
  case authenticationFailed
  case userNotFound
  case invalidResponse

  var errorDescription: String? {
    switch self {
    case .authenticationFailed:
      return "認証に失敗しました"
    case .userNotFound:
      return "ユーザーが見つかりません"
    case .invalidResponse:
      return "無効なレスポンスです"
    }
  }
}
