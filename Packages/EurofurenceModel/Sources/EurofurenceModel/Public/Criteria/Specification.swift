public protocol Specification: Equatable {
    
    associatedtype Element
    
    func isSatisfied(by element: Element) -> Bool
    
}
