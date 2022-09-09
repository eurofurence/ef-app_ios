import Foundation

extension NSOrderedSet {
    
    func array<T>(of type: T.Type) -> [T] {
        guard let array = self.array as? [T] else {
            fatalError("\(self) expected to contain a set of \(type)")
        }
        
        return array
    }
    
}
