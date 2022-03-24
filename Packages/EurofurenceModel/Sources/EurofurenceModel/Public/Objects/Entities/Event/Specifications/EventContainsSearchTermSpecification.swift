public struct EventContainsSearchTermSpecification {
    
    private let query: String
    
    public init(query: String) {
        self.query = query
    }
    
}

// MARK: - EventContainsSearchTermSpecification + Specification

extension EventContainsSearchTermSpecification: Specification {
    
    public typealias Element = Event
    
    public func isSatisfied(by element: Element) -> Bool {
        element.title.localizedCaseInsensitiveContains(query)
    }
    
}
