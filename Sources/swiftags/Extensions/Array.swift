extension Array {
  mutating func popFirst() -> Iterator.Element? {
    guard !isEmpty else { return nil }
    return removeFirst()
  }
}
