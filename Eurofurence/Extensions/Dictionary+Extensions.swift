import Foundation

extension Dictionary {
    
    func castingKeysAndValues<T, U>() -> [T: U] {
        let keysAndValues: [(T, U)] = compactMap { (key, value) -> (T, U)? in
            guard let castedKey = key as? T, let castedValue = value as? U else { return nil }
            return (castedKey, castedValue)
        }
        
        return keysAndValues.reduce(into: [T: U](), { $0[$1.0] = $1.1 })
    }
    
}
