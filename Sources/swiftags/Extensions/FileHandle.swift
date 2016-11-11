import Foundation

extension FileHandle: TextOutputStream {
  public func write(_ string: String) {
    write(string, encoding: .utf8)
  }

  public func write(_ string: String, encoding: String.Encoding) {
    guard let data = string.data(using: encoding) else {
      preconditionFailure("unable to encode string with encoding: \(encoding)")
    }

    write(data)
  }
}
