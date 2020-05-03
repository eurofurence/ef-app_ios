public struct AnyContentRepresentation {
    
    private let content: Any
    private let descriptor: (ContentRepresentationRecipient) -> Void
    private let equals: (AnyContentRepresentation) -> Bool
    
    public init<Content>(_ content: Content) where Content: ContentRepresentation {
        self.content = content
        
        descriptor = { (recipient) in
            recipient.receive(content)
        }
        
        equals = { (other) in
            guard let castedOther = other.content as? Content else { return false }
            return content == castedOther
        }
    }
    
}

// MARK: - CustomStringConvertible

extension AnyContentRepresentation: CustomStringConvertible {
    
    public var description: String {
        String(describing: content)
    }
    
}

// MARK: - CustomReflectable

extension AnyContentRepresentation: CustomReflectable {
    
    public var customMirror: Mirror {
        Mirror(reflecting: content)
    }
    
}

// MARK: - ContentRepresentationDescribing

extension AnyContentRepresentation: ContentRepresentationDescribing {
    
    public func describe(to recipient: ContentRepresentationRecipient) {
        descriptor(recipient)
    }
    
}

// MARK: - Equatable

extension AnyContentRepresentation: Equatable {
    
    public static func == (lhs: AnyContentRepresentation, rhs: AnyContentRepresentation) -> Bool {
        lhs.equals(rhs)
    }
    
}

// MARK: - Convenience Erasure

extension ContentRepresentation {
    
    public func eraseToAnyContentRepresentation() -> AnyContentRepresentation {
        AnyContentRepresentation(self)
    }
    
}
