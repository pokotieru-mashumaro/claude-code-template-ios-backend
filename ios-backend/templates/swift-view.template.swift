import SwiftUI

struct {{FEATURE_NAME}}View: View {
  @StateObject private var viewModel = {{FEATURE_NAME}}ViewModel()

  var body: some View {
    NavigationView {
      Group {
        switch viewModel.state {
        case .idle:
          emptyView
        case .loading:
          loadingView
        case .loaded(let items):
          contentView(items: items)
        case .error(let message):
          errorView(message: message)
        }
      }
      .navigationTitle("{{FEATURE_NAME}}")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: viewModel.refresh) {
            Image(systemName: "arrow.clockwise")
          }
        }
      }
    }
    .onAppear {
      viewModel.load()
    }
  }

  private var emptyView: some View {
    VStack {
      Image(systemName: "tray")
        .font(.system(size: 60))
        .foregroundColor(.gray)
      Text("データがありません")
        .foregroundColor(.gray)
    }
  }

  private var loadingView: some View {
    ProgressView()
  }

  private func contentView(items: [{{FEATURE_NAME}}]) -> some View {
    List(items) { item in
      NavigationLink(destination: {{FEATURE_NAME}}DetailView(item: item)) {
        {{FEATURE_NAME}}Row(item: item)
      }
    }
  }

  private func errorView(message: String) -> some View {
    VStack(spacing: 16) {
      Image(systemName: "exclamationmark.triangle")
        .font(.system(size: 60))
        .foregroundColor(.red)
      Text(message)
        .foregroundColor(.gray)
      Button("再試行") {
        viewModel.load()
      }
      .buttonStyle(.borderedProminent)
    }
    .padding()
  }
}

struct {{FEATURE_NAME}}Row: View {
  let item: {{FEATURE_NAME}}

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(item.name)
        .font(.headline)
      Text(item.createdAt.formatted())
        .font(.caption)
        .foregroundColor(.gray)
    }
    .padding(.vertical, 4)
  }
}

#Preview {
  {{FEATURE_NAME}}View()
}
