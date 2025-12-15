import Foundation

struct PaginatedResponse<T: Codable>: Codable {
  let items: [T]
  let pagination: Pagination
}

struct Pagination: Codable {
  let page: Int
  let limit: Int
  let total: Int
  let totalPages: Int
}
