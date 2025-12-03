import SwiftUI

struct UserListView: View {
  @StateObject private var viewModel = UserListViewModel()

  var body: some View {
    NavigationView {
      Group {
        switch viewModel.state {
        case .idle:
          Color.clear.onAppear {
            Task {
              await viewModel.fetchUsers()
            }
          }

        case .loading:
          ProgressView("読み込み中...")

        case .loaded(let users):
          List(users) { user in
            NavigationLink(destination: Text(user.name)) {
              VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                  .font(.headline)
                Text(user.email)
                  .font(.subheadline)
                  .foregroundColor(.secondary)
              }
            }
          }
          .refreshable {
            await viewModel.fetchUsers()
          }

        case .error(let error):
          VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
              .font(.largeTitle)
              .foregroundColor(.red)
            Text("エラーが発生しました")
              .font(.headline)
            Text(error.localizedDescription)
              .font(.caption)
              .foregroundColor(.secondary)
            Button("再試行") {
              Task {
                await viewModel.fetchUsers()
              }
            }
          }
          .padding()
        }
      }
      .navigationTitle("ユーザー一覧")
    }
  }
}

#Preview {
  UserListView()
}
