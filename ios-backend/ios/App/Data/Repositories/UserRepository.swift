import Foundation

final class UserRepository: UserRepositoryProtocol {
  private let remoteDataSource: UserRemoteDataSource

  init(remoteDataSource: UserRemoteDataSource = UserRemoteDataSource()) {
    self.remoteDataSource = remoteDataSource
  }

  func fetchUsers(page: Int, limit: Int) async throws -> PaginatedResponse<User> {
    try await remoteDataSource.fetchUsers(page: page, limit: limit)
  }

  func fetchUser(id: String) async throws -> User {
    try await remoteDataSource.fetchUser(id: id)
  }

  func createUser(_ user: User) async throws -> User {
    try await remoteDataSource.createUser(user)
  }

  func updateUser(_ user: User) async throws -> User {
    try await remoteDataSource.updateUser(user)
  }

  func deleteUser(id: String) async throws {
    try await remoteDataSource.deleteUser(id: id)
  }
}
