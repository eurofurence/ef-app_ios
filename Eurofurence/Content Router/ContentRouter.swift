public protocol ContentRouter {
    
    func route<Content>(_ content: Content) throws
        where Content: ContentRepresentationDescribing
    
}
