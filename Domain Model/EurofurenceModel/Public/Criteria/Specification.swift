public protocol Specification {
    
    associatedtype Element
    
    func isSatisfied(by element: Element) -> Bool
    
}
