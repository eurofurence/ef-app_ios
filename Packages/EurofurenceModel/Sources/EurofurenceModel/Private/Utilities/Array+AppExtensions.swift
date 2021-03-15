import Foundation

extension Array {

    static var empty: [Element] {
        return []
    }

}

extension Array where Element: Equatable {

    func contains(elementsFrom other: [Element]) -> Bool {
        for element in other {
            guard contains(element) else { return false }
        }

        return true
    }

}
