import EurofurenceModel

struct AlwaysPassesSpecification<T>: Specification {
    
    func isSatisfied(by element: T) -> Bool {
        true
    }
    
}
