public struct Link {

    public enum Kind: Int {
        case webExternal
    }

    public var name: String
    public var type: Kind
    public var contents: AnyHashable

    public init(name: String, type: Kind, contents: AnyHashable) {
        self.name = name
        self.type = type
        self.contents = contents
    }

}

extension Link {

    static func fromServerModel(_ link: LinkCharacteristics) -> Link {
        guard let linkKind = Link.Kind(rawValue: link.fragmentType.rawValue) else {
            fatalError("Unknown link type: \(link.fragmentType.rawValue)")
        }
        
        return Link(name: link.name, type: linkKind, contents: link.target)
    }

    static func fromServerModels(_ links: [LinkCharacteristics]) -> [Link] {
        return links.map(fromServerModel).sorted(by: { (first, second) in
            return first.name < second.name
        })
    }

}
