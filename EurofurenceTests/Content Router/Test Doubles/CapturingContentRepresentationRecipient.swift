import Eurofurence

class CapturingContentRepresentationRecipient: ContentRepresentationRecipient {
    
    private(set) var erasedRoutedContent: AnyContentRepresentation?
    func receive<Content>(_ content: Content) where Content: ContentRepresentation {
        erasedRoutedContent = content.eraseToAnyContentRepresentation()
    }
    
}
