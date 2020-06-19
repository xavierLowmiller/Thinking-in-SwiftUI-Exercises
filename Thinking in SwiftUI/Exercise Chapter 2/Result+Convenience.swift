extension Result {
  var value: Success? {
    try? get()
  }

  var errorMessage: String? {
    do {
      _ = try get()
      return nil
    } catch {
      return error.localizedDescription
    }
  }

  func tryMap<NewSuccess>(transform: (Success) throws -> NewSuccess) -> Result<NewSuccess, Error> {
    do {
      let value = try get()
      return .success(try transform(value))
    } catch {
      return .failure(error)
    }
  }

  /// Initializes a result using the `Success` value, if present.
  /// If missing, it falls back to using the `Failure`
  init(success: Success?, failure: Failure) {
    if let success = success {
      self = .success(success)
    } else {
      self = .failure(failure)
    }
  }
}
