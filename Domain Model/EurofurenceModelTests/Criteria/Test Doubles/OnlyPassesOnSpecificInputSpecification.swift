import EurofurenceModel

struct OnlyPassesOnSpecificInputSpecification<T>: Specification where T: Equatable {
    
    var passesOn: T
    
    func isSatisfied(by element: T) -> Bool {
        passesOn == element
    }
    
}
