import PackageDescription

let package = Package(
  name: "swiftags",
  dependencies: [
    .Package(url: "https://github.com/jpsim/SourceKitten.git", majorVersion: 0, minor: 15),
  ]
)
