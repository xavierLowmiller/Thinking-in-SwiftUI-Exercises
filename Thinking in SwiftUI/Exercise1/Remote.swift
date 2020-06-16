import Combine
import UIKit

typealias URLLoader = (URL, @escaping (Data?) -> Void) -> Void
typealias DataTransform<A> = (Data) -> A?

final class Remote<A>: ObservableObject {
  @Published var result: Result<A, Error>?

  let url: URL
  private let urlLoader: URLLoader
  private let transform: DataTransform<A>

  var value: A? {
    result?.value
  }

  var errorMessage: String? {
    result?.errorMessage
  }

  init(url: URL,
       urlLoader: @escaping URLLoader = loadViaURLSession,
       transform: @escaping DataTransform<A>) {
    self.url = url
    self.transform = transform
    self.urlLoader = urlLoader
  }

  func load() {
    urlLoader(url) { data in
      if let data = data, let result = self.transform(data) {
        self.result = .success(result)
      } else {
        self.result = .failure(LoadingError())
      }
    }
  }
}

private func loadViaURLSession(url: URL, completion: @escaping (Data?) -> Void) {
  Current.urlSession.dataTask(with: url) { data, _, _ in
    Current.mainQueue.async {
      completion(data)
    }
  }.resume()
}

extension Remote where A: Decodable {
  convenience init(url: URL, urlLoader: @escaping URLLoader = loadViaURLSession) {
    self.init(url: url, urlLoader: urlLoader) { data in
      try? JSONDecoder.snakeCaseDecoder.decode(A.self, from: data)
    }
  }
}

extension Remote where A == UIImage {
  convenience init(url: URL, urlLoader: @escaping URLLoader = loadViaURLSession) {
    self.init(url: url, urlLoader: urlLoader, transform: UIImage.init)
  }
}

struct LoadingError: Error {}

private extension JSONDecoder {
  static let snakeCaseDecoder: JSONDecoder = {
    $0.keyDecodingStrategy = .convertFromSnakeCase
    return $0
  }(JSONDecoder())
}
