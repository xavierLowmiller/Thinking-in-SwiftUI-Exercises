import Combine
import XCTest
@testable import Thinking_in_SwiftUI

class RemoteTests: XCTestCase {

  private struct User: Codable, Equatable {
    let name: String
  }

  func testRemoteLoad() {
    // Given
    let data: Data = """
    [{
      "name": "Test"
    }]
    """
    let remote = Remote<[User]>(
      url: URL(string: "https://example.org/users")!,
      urlLoader: { $1(.success(data)) }
    )

    // When
    remote.load()

    // Then
    XCTAssertEqual(remote.value, [User(name: "Test")])
    XCTAssertNil(remote.errorMessage)
  }

  func testNetworkError() {
    // Given
    let remote = Remote<[User]>(
      url: URL(string: "https://example.org/users")!,
      urlLoader: { $1(.failure(LoadingError())) }
    )

    // When
    remote.load()

    // Then
    XCTAssertNotNil(remote.errorMessage)
    XCTAssertNil(remote.value)
  }

  func testDecodingError() {
    // Given
    let data: Data = """
    [{
      "some": "Wrong Key"
    }]
    """
    let remote = Remote<[User]>(
      url: URL(string: "https://example.org/users")!,
      urlLoader: { $1(.success(data)) }
    )

    // When
    remote.load()

    // Then
    XCTAssertNotNil(remote.errorMessage)
    XCTAssertNil(remote.value)
  }
}
