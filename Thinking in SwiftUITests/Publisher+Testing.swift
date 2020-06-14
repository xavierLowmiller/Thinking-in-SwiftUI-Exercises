import Combine
import XCTest

private enum WaitError: Error {
  case timeout(timeout: TimeInterval)
  case noResult

  var localizedDescription: String {
    switch self {
    case .timeout(let timeout):
      return "The timeout of \(timeout) seconds was reached"
    case .noResult:
      return "The publisher completed without producing a result"
    }
  }
}

extension Publisher {
  func waitOne(timeout: TimeInterval = 10) throws -> Output {
    let results = try wait()
    if results.isEmpty {
      throw WaitError.noResult
    } else {
      return results[0]
    }
  }

  func wait(timeout: TimeInterval = 10) throws -> [Output] {
    let exp = XCTestExpectation(description: #function)

    var output: [Output] = []
    var error: Failure?

    let token = sink(receiveCompletion: { completion in
      switch completion {
      case .finished:
        exp.fulfill()
      case .failure(let failure):
        error = failure
      }
    }, receiveValue: {
      output.append($0)
    })

    let waiter = XCTWaiter()
    let waitResult = waiter.wait(for: [exp], timeout: timeout)

    token.cancel()

    if waitResult == .timedOut {
      throw WaitError.timeout(timeout: timeout)
    }

    if let error = error {
      throw error
    }

    return output
  }
}
