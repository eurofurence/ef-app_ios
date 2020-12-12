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
    
}


// MARK: Convenience Creation

extension Specification {
    
    public func and<Other: Specification>(
        _ other: Other
    ) -> AndSpecification<Self, Other> where Other.Element == Element {
        AndSpecification(self, second: other)
    }
    
}
