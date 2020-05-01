import Eurofurence

class CapturingContentRepresentationRecipient: ContentRepresentationRecipient {
    
    private(set) var receivedContent: Any?
    func receive<Content>(_ content: Content) where Content: ContentRepresentation {
        receivedContent = content
    }
    
}
