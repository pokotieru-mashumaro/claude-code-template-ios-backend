import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
  case patch = "PATCH"
}

enum NetworkError: Error {
  case invalidURL
  case invalidResponse
  case httpError(statusCode: Int)
  case decodingError
  case unknown
}

final class NetworkService {
  static let shared = NetworkService()

  private let baseURL: String
  private let session: URLSession

  private init() {
    // TODO: 環境変数から取得
    self.baseURL = "http://localhost:3000"
    self.session = URLSession.shared
  }

  func request<T: Decodable>(
    endpoint: String,
    method: HTTPMethod,
    body: (any Encodable)? = nil,
    headers: [String: String]? = nil
  ) async throws -> T {
    guard let url = URL(string: baseURL + endpoint) else {
      throw NetworkError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    // カスタムヘッダー追加
    headers?.forEach { key, value in
      request.setValue(value, forHTTPHeaderField: key)
    }

    // Body追加
    if let body = body {
      request.httpBody = try JSONEncoder().encode(body)
    }

    let (data, response) = try await session.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.invalidResponse
    }

    guard (200...299).contains(httpResponse.statusCode) else {
      throw NetworkError.httpError(statusCode: httpResponse.statusCode)
    }

    do {
      let apiResponse = try JSONDecoder().decode(ApiResponse<T>.self, from: data)
      guard let responseData = apiResponse.data else {
        throw NetworkError.decodingError
      }
      return responseData
    } catch {
      throw NetworkError.decodingError
    }
  }
}

// API Response型
struct ApiResponse<T: Decodable>: Decodable {
  let success: Bool
  let data: T?
  let error: ApiError?
}

struct ApiError: Decodable {
  let code: String
  let message: String
  let details: String?
}
