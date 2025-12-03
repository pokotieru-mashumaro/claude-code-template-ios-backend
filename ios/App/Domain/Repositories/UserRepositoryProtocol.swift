import Foundation

protocol UserRepositoryProtocol {
  func fetchUsers(page: Int, limit: Int) async throws -> PaginatedResponse<User>
  func fetchUser(id: String) async throws -> User
  func createUser(_ user: User) async throws -> User
  func updateUser(_ user: User) async throws -> User
  func deleteUser(id: String) async throws
}
