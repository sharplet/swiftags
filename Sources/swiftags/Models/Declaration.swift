struct Declaration {
  enum Kind: String {
    case `class` = "source.lang.swift.decl.class"
    case `struct` = "source.lang.swift.decl.struct"
    case `enum` = "source.lang.swift.decl.enum"
    case `protocol` = "source.lang.swift.decl.protocol"
    case `extension` = "source.lang.swift.decl.extension"
    case freeFunction = "source.lang.swift.decl.function.free"
    case instanceMethod = "source.lang.swift.decl.function.method.instance"
    case staticMethod = "source.lang.swift.decl.function.method.static"
    case instanceVariable = "source.lang.swift.decl.var.instance"
    case staticVariable = "source.lang.swift.decl.var.static"
    case globalVariable = "source.lang.swift.decl.var.global"
  }

  let kind: Kind
  let name: String
  let file: String
  let parsedDeclaration: String?
  let subdeclarations: LazyCollection<AnyCollection<Declaration>>

  init?(file: String, json: [String: Any]) {
    guard let kind = (json["key.kind"] as? String).flatMap(Kind.init(rawValue:)),
      let name = json["key.name"] as? String
      else { return nil }

    self.kind = kind
    self.name = name
    self.file = file
    self.parsedDeclaration = json["key.parsed_declaration"] as? String

    let subdeclarations = (json["key.substructure"] as? [[String: Any]] ?? [])
      .lazy
      .flatMap { Declaration(file: file, json: $0) }

    self.subdeclarations = AnyCollection(subdeclarations).lazy
  }

  var recursiveDeclarations: AnySequence<Declaration> {
    return AnySequence { () -> AnyIterator<Declaration> in
      var queue: [Declaration] = [self]

      return AnyIterator {
        if let next = queue.popFirst() {
          queue.insert(contentsOf: next.subdeclarations, at: 0)
          return next
        } else {
          return nil
        }
      }
    }
  }
}
