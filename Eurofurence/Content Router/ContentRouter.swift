public protocol ContentRouter: AnyObject {
    
    func route<Content>(_ content: Content) throws
        where Content: ContentRepresentationDescribing
    
}
