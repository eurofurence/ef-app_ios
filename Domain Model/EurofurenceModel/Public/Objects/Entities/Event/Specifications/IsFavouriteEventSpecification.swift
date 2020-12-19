public struct IsFavouriteEventSpecification {
    
    public init() {
        
    }
    
}

// MARK: IsFavouriteEventSpecification + Specification

extension IsFavouriteEventSpecification: Specification {
    
    public func isSatisfied(by element: Event) -> Bool {
        element.isFavourite
    }
    
}
