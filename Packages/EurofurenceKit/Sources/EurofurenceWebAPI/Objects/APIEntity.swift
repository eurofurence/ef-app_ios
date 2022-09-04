public protocol APIEntity: Decodable, Identifiable where Self.ID == String { }
