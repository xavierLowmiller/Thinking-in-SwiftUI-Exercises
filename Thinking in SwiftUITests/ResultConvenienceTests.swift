import XCTest
@testable import Thinking_in_SwiftUI

final class ResultConvenienceTests: XCTestCase {
  func testGetters() {
    // Given
    let success = Result<Int, Error>.success(5)
    let failure = Result<Int, Error>.failure(LoadingError())

    // Then
    XCTAssertEqual(success.value, 5)
    XCTAssertNil(success.errorMessage)

    XCTAssertNil(failure.value)
    XCTAssertEqual(failure.errorMessage, LoadingError().localizedDescription)
  }

  func testTryMapSuccess() {
    // Given
    let result = Result<Int, Error>.success(5)

    // When
    let mapped = result.tryMap(transform: String.init)

    // Then
    XCTAssertEqual(mapped.value, "5")
  }

  func testTryMapFailureInMap() {
    // Given
    let result = Result<Int, Error>.success(5)

    // When
    let mapped = result.tryMap(transform: { _ in throw LoadingError() })

    // Then
    XCTAssertEqual(mapped.errorMessage, LoadingError().localizedDescription)
  }

  func testTryMapFailureFailedBeforeMap() {
    // Given
    let result = Result<Int, Error>.failure(LoadingError())

    // When
    let mapped = result.tryMap(transform: String.init)

    // Then
    XCTAssertEqual(mapped.errorMessage, LoadingError().localizedDescription)
  }

  func testInitWithOptionalSuccessSuccess() {
    // Given
    let value: Int? = 5
    let error = LoadingError()

    // When
    let result = Result(success: value, failure: error)

    // Then
    XCTAssertEqual(result, .success(5))
  }

  func testInitWithOptionalSuccessFailure() {
    // Given
    let value: Int? = nil
    let error = LoadingError()

    // When
    let result = Result(success: value, failure: error)

    // Then
    XCTAssertEqual(result, .failure(LoadingError()))
  }
}
