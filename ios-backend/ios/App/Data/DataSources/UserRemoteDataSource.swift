import Foundation

final class UserRemoteDataSource {
  private let networkService: NetworkService

  init(networkService: NetworkService = NetworkService.shared) {
    self.networkService = networkService
  }

  func fetchUsers(page: Int, limit: Int) async throws -> PaginatedResponse<User> {
    let endpoint = "/api/users?page=\(page)&limit=\(limit)"
    return try await networkService.request(endpoint: endpoint, method: .get)
  }

  func fetchUser(id: String) async throws -> User {
    let endpoint = "/api/users/\(id)"
    return try await networkService.request(endpoint: endpoint, method: .get)
  }

  func createUser(_ user: User) async throws -> User {
    let endpoint = "/api/users"
    return try await networkService.request(
      endpoint: endpoint,
      method: .post,
      body: user
    )
  }

  func updateUser(_ user: User) async throws -> User {
    let endpoint = "/api/users/\(user.id)"
    return try await networkService.request(
      endpoint: endpoint,
      method: .put,
      body: user
    )
  }

  func deleteUser(id: String) async throws {
    let endpoint = "/api/users/\(id)"
    try await networkService.request(endpoint: endpoint, method: .delete)
  }
}
