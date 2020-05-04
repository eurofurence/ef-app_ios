public protocol ContentRoute {
    
    associatedtype Content: ContentRepresentation
    
    func route(_ content: Content)
    
}
