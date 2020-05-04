import Foundation

public protocol ContentRepresentationDescribing {
    
    func describe(to recipient: ContentRepresentationRecipient)
    
}

public protocol ContentRepresentationRecipient {
    
    func receive<Content>(_ content: Content) where Content: ContentRepresentation
    
}
