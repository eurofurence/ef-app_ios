extension Sequence {
    
    func sorted<T>(by keyPath: KeyPath<Element, T>) -> [Self.Element] where T: Comparable {
        sorted { (first, second) -> Bool in
            first[keyPath: keyPath] < second[keyPath: keyPath]
        }
    }
    
}
