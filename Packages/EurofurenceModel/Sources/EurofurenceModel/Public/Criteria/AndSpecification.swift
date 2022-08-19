public struct AndSpecification<
    First: Specification,
    Second: Specification
> where First.Element == Second.Element {
    
    private let first: First
    private let second: Second
    
    init(_ first: First, second: Second) {
        self.first = first
        self.second = second
    }
    
}

// MARK: AndSpecification + Specification

extension AndSpecification: Specification {
    
    public typealias Element = First.Element
    
    public func isSatisfied(by element: Element) -> Bool {
        first.isSatisfied(by: element) && second.isSatisfied(by: element)
    }
    
    public func contains<S>(_ specification: S.Type) -> Bool {
        first.contains(specification) || second.contains(specification)
    }
    
}

// MARK: Convenience Creation

@inline(__always)
public func && <
    S1: Specification,
    S2: Specification
> (_ s1: S1, _ s2: S2) -> AndSpecification<S1, S2> where S1.Element == S2.Element {
    s1.and(s2)
}

extension Specification {
    
    public func and<Other: Specification>(
        _ other: Other
    ) -> AndSpecification<Self, Other> where Other.Element == Element {
        AndSpecification(self, second: other)
    }
    
}
