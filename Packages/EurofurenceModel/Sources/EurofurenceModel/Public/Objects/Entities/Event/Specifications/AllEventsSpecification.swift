public struct AllEventsSpecification: Specification {
    
    public init() {
        
    }
    
    public typealias Element = Event
    
    public func isSatisfied(by element: Element) -> Bool {
        true
    }
    
}
