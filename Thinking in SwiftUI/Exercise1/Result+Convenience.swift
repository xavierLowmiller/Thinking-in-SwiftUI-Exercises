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
}
