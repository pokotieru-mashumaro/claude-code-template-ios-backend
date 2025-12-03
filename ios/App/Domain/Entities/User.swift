import Foundation

struct User: Identifiable, Codable, Equatable {
  let id: String
  let email: String
  let name: String
  let createdAt: Date
  let updatedAt: Date
}
