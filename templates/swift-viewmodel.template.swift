import Foundation
import Combine

@MainActor
class {{FEATURE_NAME}}ViewModel: ObservableObject {
  enum State {
    case idle
    case loading
    case loaded([{{FEATURE_NAME}}])
    case error(String)
  }

  @Published var state: State = .idle

  private let repository: {{FEATURE_NAME}}RepositoryProtocol
  private var cancellables = Set<AnyCancellable>()

  init(repository: {{FEATURE_NAME}}RepositoryProtocol = {{FEATURE_NAME}}Repository()) {
    self.repository = repository
  }

  func load() {
    state = .loading

    Task {
      do {
        let items = try await repository.fetchAll()
        state = .loaded(items)
      } catch {
        state = .error(error.localizedDescription)
      }
    }
  }

  func refresh() {
    load()
  }

  func delete(item: {{FEATURE_NAME}}) {
    Task {
      do {
        try await repository.delete(id: item.id)
        load() // 再読み込み
      } catch {
        state = .error("削除に失敗しました")
      }
    }
  }
}
