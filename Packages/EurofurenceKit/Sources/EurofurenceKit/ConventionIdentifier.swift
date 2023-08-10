public struct ConventionIdentifier: Equatable {
    
    let stringValue: String
    
    public init(_ stringValue: String) {
        self.stringValue = stringValue
    }
    
}

// MARK: - Current Convention Identifier

extension ConventionIdentifier {
    
    public static let current = ConventionIdentifier("EF27")
    
}
