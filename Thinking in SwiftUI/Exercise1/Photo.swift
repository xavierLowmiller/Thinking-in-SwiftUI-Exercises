import Foundation

struct Photo: Codable, Equatable {
  let id: String
  let author: String
  let width: Int
  let height: Int
  let url: URL
  let downloadUrl: URL
}
