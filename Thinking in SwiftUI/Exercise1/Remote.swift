import Combine
import Foundation

final class Remote<A: Decodable>: ObservableObject {
  @Published var data: Result<A, Error>?

  let url: URL

  var value: A? {
    data?.value
  }

  var errorMessage: String? {
    data?.errorMessage
  }

  init(url: URL) {
    self.url = url
  }

  func refresh() {
    Current.urlSession.loadAndDecode(url: url) { [weak self] result in
      self?.data = result
    }
  }
}
