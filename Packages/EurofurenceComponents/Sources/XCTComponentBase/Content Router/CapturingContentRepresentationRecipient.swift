import ComponentBase

public class CapturingContentRepresentationRecipient: ContentRepresentationRecipient {
    
    public init() {
        
    }
    
    public private(set) var erasedRoutedContent: AnyContentRepresentation?
    public func receive<Content>(_ content: Content) where Content: ContentRepresentation {
        erasedRoutedContent = content.eraseToAnyContentRepresentation()
    }
    
}
