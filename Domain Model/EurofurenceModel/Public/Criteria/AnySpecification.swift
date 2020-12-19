public struct AnySpecification<T> {
    
    private let _isSatisfied: (T) -> Bool
    
    init<S>(_ specification: S) where S: Specification, S.Element == T {
        _isSatisfied = { (input) in
            specification.isSatisfied(by: input)
        }
    }
    
    public func isSatisfied(by element: T) -> Bool {
        _isSatisfied(element)
    }
    
}

// MARK: - Convenience Creation

extension Specification {
    
    public func eraseToAnySpecification() -> AnySpecification<Element> {
        AnySpecification(self)
    }
    
}
