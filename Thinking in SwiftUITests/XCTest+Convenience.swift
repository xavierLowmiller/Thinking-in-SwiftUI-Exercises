import Foundation

extension Data: ExpressibleByStringLiteral {
  public init(stringLiteral value: StringLiteralType) {
    self = value.data(using: .utf8) ?? Data()
  }
}
