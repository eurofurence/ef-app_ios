import Foundation

public protocol ContentRepresentation: ContentRepresentationDescribing, Equatable {
    
}

// MARK: - Convenience self-describing implementation

extension ContentRepresentation {
    
    public func describe(to recipient: ContentRepresentationRecipient) {
        recipient.receive(self)
    }
    
}
