import Foundation
import SourceKittenFramework

let arguments = Array(CommandLine.arguments.dropFirst())

guard arguments.count == 2 else {
  fail("error: invalid number of arguments")
}

let selectedModule: SourceKittenFramework.Module

switch (arguments[0], arguments[1]) {
case ("--spm-module", let name):
  guard let module = Module(spmName: name) else {
    fail("error: invalid module \(name)")
  }
  selectedModule = module
default:
  fail("error: unsupported options \(arguments)")
}

let docs = selectedModule.docs

let allDeclarations = docs.lazy
  .flatMap { swiftDocs -> AnyCollection<Declaration> in
    guard let file = swiftDocs.file.path else { return AnyCollection([]) }
    let rawDeclarations = swiftDocs.docsDictionary["key.substructure"] as? [[String: Any]] ?? []
    return AnyCollection(rawDeclarations.lazy.flatMap { Declaration(file: file, json: $0) })
  }
  .flatMap { $0.recursiveDeclarations }

var tagFile: FileHandle
do {
  let url = URL(fileURLWithPath: "./tags")
  FileManager.default.createFile(atPath: url.path, contents: nil)
  tagFile = try FileHandle(forWritingTo: url)
} catch {
  fail("fatal: unable to open file 'tags' for writing: \(error)")
}

print("!_TAG_FILE_FORMAT", 2, "/extended format; --format=1 will not append ;\" to lines/", separator: "\t", to: &tagFile)
print("!_TAG_FILE_SORTED", 1, "/0=unsorted, 1=sorted, 2=foldcase/", separator: "\t", to: &tagFile)

for declaration in allDeclarations.sorted(by: { $0.name < $1.name }) {
  guard let parsedDeclaration = declaration.parsedDeclaration?.firstLine else { continue }
  let excmd = "/\(parsedDeclaration)/;\""
  print(declaration.name, declaration.file, excmd, declaration.kind.ctagsKind, separator: "\t", to: &tagFile)
}
