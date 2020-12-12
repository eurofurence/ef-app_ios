public protocol Rule {
    
    associatedtype Element
    
    func isSatisfied(by element: Element) -> Bool
    
}
