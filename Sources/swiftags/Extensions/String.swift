extension String {
  var firstLine: String? {
    var line: String?
    enumerateLines { line = $0; $1 = true }
    return line
  }
}
