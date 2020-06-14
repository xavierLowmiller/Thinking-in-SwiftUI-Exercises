import Combine
import Foundation

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
}

private extension JSONDecoder {
  static let snakeCaseDecoder: JSONDecoder = {
    $0.keyDecodingStrategy = .convertFromSnakeCase
    return $0
  }(JSONDecoder())
}
