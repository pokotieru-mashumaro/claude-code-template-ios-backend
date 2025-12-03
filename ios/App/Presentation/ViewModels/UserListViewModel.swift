import Foundation
import Combine

@MainActor
final class UserListViewModel: ObservableObject {
  @Published var state: ViewState<[User]> = .idle

  private let repository: UserRepositoryProtocol
  private var cancellables = Set<AnyCancellable>()

  init(repository: UserRepositoryProtocol = UserRepository()) {
    self.repository = repository
  }

  func fetchUsers(page: Int = 1, limit: Int = 20) async {
    state = .loading

    do {
      let response = try await repository.fetchUsers(page: page, limit: limit)
      state = .loaded(response.items)
    } catch {
      state = .error(error)
    }
  }
}

enum ViewState<T> {
  case idle
  case loading
  case loaded(T)
  case error(Error)
}
