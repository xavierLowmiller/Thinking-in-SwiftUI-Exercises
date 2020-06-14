import Combine
import XCTest
@testable import Thinking_in_SwiftUI

class TestURLSessionLoadAndDecode: XCTestCase {

  private struct User: Codable, Equatable {
    let name: String
  }

  let testSession: URLSession = {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [ConfigurableURLProtocol.classForCoder()]
    return URLSession(configuration: configuration)
  }()

  func testSuccessfulLoad() throws {
    // Given
    ConfigurableURLProtocol.nextData = """
    [{
      "name": "Test"
    }]
    """.data(using: .utf8)!
    ConfigurableURLProtocol.error = nil

    let expected = [User(name: "Test")]

    // When
    let result = try testSession
      .loadAndDecode([User].self, url: URL(string: "https://example.org/users")!)
      .waitOne()

    XCTAssertEqual(try result.get(), expected)
  }

  func testNetworkError() throws {
    // Given
    struct TestNetworkError: Error {}
    ConfigurableURLProtocol.error = TestNetworkError()

    // When
    let result = try testSession
      .loadAndDecode([User].self, url: URL(string: "https://example.org/users")!)
      .waitOne()

    // Then
    XCTAssertThrowsError(try result.get())
  }

  func testDecodingError() throws {
    // Given
    ConfigurableURLProtocol.nextData = """
    [{
      "some": "wrong key"
    }]
    """.data(using: .utf8)!
    ConfigurableURLProtocol.error = nil

    // When
    let result = try testSession
      .loadAndDecode([User].self, url: URL(string: "https://example.org/users")!)
      .waitOne()

    // Then
    XCTAssertThrowsError(try result.get())
  }
}

private class ConfigurableURLProtocol: URLProtocol {
  static var nextData = Data()
  static var nextResponseCode = 200
  static var nextHeaderFields: [String: String]? = nil
  static var httpVersion = "1.1"
  static var error: Error? = nil

  override class func canInit(with request: URLRequest) -> Bool { true }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

  override func startLoading() {

    if let error = Self.error {
      client?.urlProtocol(self, didFailWithError: error)
    } else {

      let response = HTTPURLResponse(
        url: request.url!,
        statusCode: Self.nextResponseCode,
        httpVersion: Self.httpVersion,
        headerFields: Self.nextHeaderFields
        )!
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
      client?.urlProtocol(self, didLoad: Self.nextData)
      client?.urlProtocolDidFinishLoading(self)
    }
  }

  override func stopLoading() {}
}
