public struct AnySpecification<T> {
    
    private let _erased: Any
    private let _isSatisfied: (T) -> Bool
    private let _equals: (AnySpecification<T>) -> Bool
    private let _contains: (SpecificationContainsTesting) -> Bool
    
    init<S>(_ specification: S) where S: Specification, S.Element == T {
        _erased = specification
        
        _isSatisfied = { (input) in
            specification.isSatisfied(by: input)
        }
        
        _equals = { (other) in
            guard let spec = other._erased as? S else { return false }
            return specification == spec
        }
        
        _contains = { (test) in
            test.evaluate(against: specification)
        }
    }
    
    public func isSatisfied(by element: T) -> Bool {
        _isSatisfied(element)
    }
    
    public func contains<S>(_ specification: S.Type) -> Bool where S: Specification {
        _contains(CheckContainsSpecificationTesting<S>())
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

// MARK: - Testing Containment

private protocol SpecificationContainsTesting {
    
    func evaluate<S>(against specification: S) -> Bool where S: Specification
    
}

private struct CheckContainsSpecificationTesting<S>: SpecificationContainsTesting where S: Specification {
    
    func evaluate<T>(against specification: T) -> Bool where T: Specification {
        specification.contains(S.self)
    }
    
}
