import Foundation

public struct Day {

    public var date: Date
    public var identifier: String

    public init(date: Date, identifier: String) {
        self.date = date
        self.identifier = identifier
    }

}

extension Day: Comparable {
    
    public static func < (lhs: Day, rhs: Day) -> Bool {
        return lhs.date < rhs.date
    }
    
}

extension Day: Equatable {

    public static func == (lhs: Day, rhs: Day) -> Bool {
        return lhs.date == rhs.date
    }

}
