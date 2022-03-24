public struct AnySpecification<T> {
    
    private let _erased: Any
    private let _isSatisfied: (T) -> Bool
    private let _equals: (AnySpecification<T>) -> Bool
    
    init<S>(_ specification: S) where S: Specification, S.Element == T {
        _erased = specification
        
        _isSatisfied = { (input) in
            specification.isSatisfied(by: input)
        }
        
        _equals = { (other) in
            guard let spec = other._erased as? S else { return false }
            return specification == spec
        }
    }
    
    public func isSatisfied(by element: T) -> Bool {
        _isSatisfied(element)
    }
    
}

// MARK: - AnySpecification + CustomReflectable

extension AnySpecification: CustomReflectable {
    
    public var customMirror: Mirror {
        Mirror(reflecting: _erased)
    }
    
}

// MARK: - AnySpecification + Equatable

extension AnySpecification: Equatable {
    
    public static func == (lhs: AnySpecification<T>, rhs: AnySpecification<T>) -> Bool {
        lhs._equals(rhs)
    }
    
}

// MARK: - Convenience Creation

extension Specification {
    
    public func eraseToAnySpecification() -> AnySpecification<Element> {
        AnySpecification(self)
    }
    
}
