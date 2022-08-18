import Foundation

public struct WeakCollection<T> {
    
    private let storage = NSHashTable<AnyObject>.weakObjects()
    private var highRank = [ObjectIdentifier]()
    private var lowRank = [ObjectIdentifier]()
    
    public enum PreferredOrdering {
        case none
        case last
    }
    
    public init() {
        
    }
    
    public mutating func add(_ element: AnyObject, preferredOrder: PreferredOrdering = .none) {
        storage.add(element)
        
        let rank = ObjectIdentifier(element)
        
        switch preferredOrder {
        case .none:
            highRank.append(rank)
            
        case .last:
            lowRank.append(rank)
        }
    }
    
    public mutating func remove(_ element: AnyObject) {
        storage.remove(element)
        
        let rank = ObjectIdentifier(element)
        if let idx = highRank.firstIndex(of: rank) {
            highRank.remove(at: idx)
        }
        
        if let idx = lowRank.firstIndex(of: rank) {
            lowRank.remove(at: idx)
        }
    }
    
    public func forEach(_ block: (T) throws -> Void) rethrows {
        let objects = storage.allObjects.compactMap({ $0 })
        let objectsByRank = objects.map { obj -> (ObjectIdentifier, AnyObject) in (ObjectIdentifier(obj), obj) }
        let orderedObjects = objectsByRank.sorted { first, second in
            return rank(for: first.0) > rank(for: second.0)
        }
        
        for (_, element) in orderedObjects {
            if let element = element as? T {
                try block(element)
            }
        }
    }
    
    private func rank(for objectIdentifier: ObjectIdentifier) -> Int {
        if let low = lowRank.firstIndex(of: objectIdentifier) {
            return low
        }
        
        if let high = highRank.firstIndex(of: objectIdentifier) {
            return lowRank.count + high
        }
        
        return -1
    }
    
}
