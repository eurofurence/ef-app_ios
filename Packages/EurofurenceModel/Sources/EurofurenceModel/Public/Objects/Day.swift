import Foundation

public struct Day {

    public var date: Date

    public init(date: Date) {
        self.date = date
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
