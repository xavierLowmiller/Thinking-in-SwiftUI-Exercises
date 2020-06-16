import Combine
import UIKit

typealias URLLoader = (URL, @escaping (Result<Data, Error>) -> Void) -> Void
typealias DataTransform<A> = (Result<Data, Error>) -> Result<A, Error>

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
    urlLoader(url) { result in
      self.result = self.transform(result)
    }
  }
}

private func loadViaURLSession(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
  Current.urlSession.dataTask(with: url) { data, _, error in
    Current.mainQueue.async {
      completion(Result(success: data, failure: error ?? LoadingError()))
    }
  }.resume()
}

extension Remote where A: Decodable {
  convenience init(url: URL, urlLoader: @escaping URLLoader = loadViaURLSession) {
    self.init(url: url, urlLoader: urlLoader) { result in
      result.tryMap { data in
        try JSONDecoder.snakeCaseDecoder.decode(A.self, from: data)
      }
    }
  }
}

extension Remote where A == UIImage {
  convenience init(url: URL, urlLoader: @escaping URLLoader = loadViaURLSession) {
    self.init(url: url, urlLoader: urlLoader) { result in
      result.tryMap { data in
        if let image = UIImage(data: data) {
          return image
        } else {
          throw ImageDecodingError()
        }
      }
    }
  }
}

struct LoadingError: Error {}
struct ImageDecodingError: Error {}

private extension JSONDecoder {
  static let snakeCaseDecoder: JSONDecoder = {
    $0.keyDecodingStrategy = .convertFromSnakeCase
    return $0
  }(JSONDecoder())
}
