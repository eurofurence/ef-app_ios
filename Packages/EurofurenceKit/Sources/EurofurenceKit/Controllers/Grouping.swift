import Foundation

/// A collection of elements grouped by a common ideentifier.
public struct Grouping<ID, Element> where ID: Identifiable {
    
    /// The identifier of the group of associated elements.
    public let id: ID
    
    /// The collection of grouped elements associated with the common identifier.
    public let elements: [Element]
    
    init(id: ID, elements: [Element]) {
        self.id = id
        self.elements = elements
    }
    
}
