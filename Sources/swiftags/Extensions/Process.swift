import Foundation

extension Process {
  struct Error: Swift.Error {
    var status: Int32
    var reason: TerminationReason
  }

  var error: Error? {
    guard !isRunning else { return nil }
    return Error(status: terminationStatus, reason: terminationReason)
  }
}
