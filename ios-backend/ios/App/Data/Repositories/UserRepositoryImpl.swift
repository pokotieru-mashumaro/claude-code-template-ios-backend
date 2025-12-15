import Foundation

/// UserRepositoryの実装（Supabase版）
final class UserRepositoryImpl: UserRepository {
  private let supabase = SupabaseClientManager.shared

  func getUsers() async throws -> [User] {
    return try await supabase.fetchUsers()
  }

  func getUser(id: String) async throws -> User? {
    return try await supabase.fetchUser(id: id)
  }

  func createUser(_ user: User) async throws -> User {
    return try await supabase.createUser(user)
  }

  func updateUser(id: String, name: String) async throws -> User {
    return try await supabase.updateUser(id: id, name: name)
  }

  func deleteUser(id: String) async throws {
    try await supabase.deleteUser(id: id)
  }
}
