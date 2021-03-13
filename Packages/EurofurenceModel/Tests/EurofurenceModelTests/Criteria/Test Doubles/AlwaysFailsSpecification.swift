import EurofurenceModel

struct AlwaysFailsSpecification<T>: Specification {
    
    func isSatisfied(by element: T) -> Bool {
        false
    }
    
}
