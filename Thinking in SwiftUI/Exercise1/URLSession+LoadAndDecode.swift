import Combine
import UIKit

extension URLSession {
  func loadAndDecode<A: Decodable>(_ type: A.Type, url: URL, decoder: JSONDecoder = .snakeCaseDecoder)
    -> AnyPublisher<Result<A, Error>, Never> {
      dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: type, decoder: decoder)
        .map { .success($0) }
        .catch { Just(.failure($0)) }
        .eraseToAnyPublisher()
  }

  func loadAndDecode<A: Decodable>(url: URL, completion: @escaping (Result<A, Error>) -> Void) {
    var result: Result<A, Error>?
    var token: AnyCancellable?

    token = Current.urlSession
      .loadAndDecode(A.self, url: url)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { _ in
        token?.cancel()
        if let result = result {
          completion(result)
        } else {
          fatalError()
        }
      }, receiveValue: { value in
        result = value
      })
  }

  func loadImage(at url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
    var token: AnyCancellable?
    token = Current.urlSession
      .dataTaskPublisher(for: url)
      .map(\.data)
      .compactMap(UIImage.init)
      .map { Result.success($0) }
      .catch { Just(.failure($0 as Error)) }
      .receive(on: DispatchQueue.main)
      .sink {
        completion($0)
        token?.cancel()
    }
  }
}

private extension JSONDecoder {
  static let snakeCaseDecoder: JSONDecoder = {
    $0.keyDecodingStrategy = .convertFromSnakeCase
    return $0
  }(JSONDecoder())
}
