import Foundation

extension Array where Element: Equatable {

    func equalsIgnoringOrder(_ other: [Element]) -> Bool {
        guard count == other.count else { return false }
        return other.filter(contains).count == count
    }

    func contains(elementsFrom other: [Element]) -> Bool {
        return other.allSatisfy(contains)
    }
    
    func contains(elementsFrom other: [Element]?) -> Bool {
        guard let other = other else { return false }
        return contains(elementsFrom: other)
    }
    
    func containsAny(elementsFrom other: [Element]) -> Bool {
        return other.first(where: contains) != nil
    }

}
