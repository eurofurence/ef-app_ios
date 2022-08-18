import Foundation

public struct WeakCollection<T> {
    
    private let storage = NSHashTable<AnyObject>.weakObjects()
    private var order = [ObjectIdentifier]()
    
    public init() {
        
    }
    
    public mutating func add(_ element: AnyObject) {
        storage.add(element)
        order.append(ObjectIdentifier(element))
    }
    
    public mutating func remove(_ element: AnyObject) {
        storage.remove(element)
        
        let rank = ObjectIdentifier(element)
        if let idx = order.firstIndex(of: rank) {
            order.remove(at: idx)
        }
    }
    
    public func forEach(_ block: (T) throws -> Void) rethrows {
        let objects = storage.allObjects.compactMap({ $0 })
        let objectsByRank = objects.map { object -> (ObjectIdentifier, AnyObject) in (ObjectIdentifier(object), object) }
        let orderedObjects = objectsByRank.sorted { first, second in
            let (firstIndex, secondIndex) = (order.firstIndex(of: first.0), order.firstIndex(of: second.0))
            return (firstIndex ?? -1) < (secondIndex ?? -1)
        }
        
        for (_, element) in orderedObjects {
            if let element = element as? T {
                try block(element)
            }
        }
    }
    
}
