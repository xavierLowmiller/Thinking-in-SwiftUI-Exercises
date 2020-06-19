import Foundation

struct Photo: Codable, Equatable, Identifiable {
  let id: String
  let author: String
  let width: Int
  let height: Int
  let url: URL
  let downloadUrl: URL
}

#if DEBUG
extension Photo {
  static let testValue = Photo(
    id: "0",
    author: "Alejandro Escamilla",
    width: 5616,
    height: 3744,
    url: URL(string: "https://unsplash.com/photos/yC-Yzbqy7PY")!,
    downloadUrl: URL(string: "https://picsum.photos/id/0/5616/3744")!
  )
}
#endif
