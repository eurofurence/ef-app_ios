import Foundation

public struct WeakCollection<T> {
    
    private let storage = NSHashTable<AnyObject>.weakObjects()
    
    public init() {
        
    }
    
    public mutating func add(_ element: T) {
        storage.add(element as AnyObject)
    }
    
    public mutating func remove(_ element: T) {
        storage.remove(element as AnyObject)
    }
    
    public func forEach(_ block: (T) throws -> Void) rethrows {
        for element in storage.allObjects.compactMap({ $0 as? T }) {
            try block(element)
        }
    }
    
}
