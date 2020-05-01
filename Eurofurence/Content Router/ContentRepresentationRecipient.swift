import Foundation

public protocol ContentRepresentationRecipient {
    
    func receive<Content>(_ content: Content) where Content: ContentRepresentation
    
}

extension ContentRepresentation {
    
    public func describe(to recipient: ContentRepresentationRecipient) {
        recipient.receive(self)
    }
    
}
