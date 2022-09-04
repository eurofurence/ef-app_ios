import Foundation

public struct AuthenticationToken: Hashable {
    
    let stringValue: String
    
    public init(_ stringValue: String) {
        self.stringValue = stringValue
    }
    
}

// MARK: - AuthenticationToken + Codable

extension AuthenticationToken: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        stringValue = try container.decode(String.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(stringValue)
    }
    
}

// MARK: - AuthenticationToken + RawRepresentable

extension AuthenticationToken: RawRepresentable {
    
    public typealias RawValue = String
    
    public var rawValue: String {
        stringValue
    }
    
    public init(rawValue: RawValue) {
        stringValue = rawValue
    }
    
}
