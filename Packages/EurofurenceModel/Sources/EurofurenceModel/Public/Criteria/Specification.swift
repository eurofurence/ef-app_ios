public protocol Specification: Equatable {
    
    associatedtype Element
    
    func isSatisfied(by element: Element) -> Bool
    func contains<S>(_ other: S.Type) -> Bool where S: Specification
    
}

extension Specification {
    
    public func contains<S>(_ specification: S.Type) -> Bool {
        self is S
    }
    
}
