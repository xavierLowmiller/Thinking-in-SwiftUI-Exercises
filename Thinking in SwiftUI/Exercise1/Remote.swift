import Combine
import UIKit

final class Remote<A>: ObservableObject {
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
}

extension Remote where A == UIImage {
  func refresh() {
    Current.urlSession.loadImage(at: url) { [weak self] result in
      self?.data = result
    }
  }
}

extension Remote where A: Decodable {
  func refresh() {
    Current.urlSession.loadAndDecode(url: url) { [weak self] result in
      self?.data = result
    }
  }
}
