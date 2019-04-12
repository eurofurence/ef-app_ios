import Foundation

public protocol Identifyable {
    
    associatedtype Identifier: Equatable
    
    var identifier: Identifier { get }
    
}

public extension Array where Element: Identifyable {
    
    var identifiers: [Element.Identifier] {
        return map({ $0.identifier })
    }
    
}
