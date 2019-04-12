import Foundation

public struct FoundationDateDistanceCalculator: DateDistanceCalculator {

    public init() {

    }

    public func calculateDays(between first: Date, and second: Date) -> Int {
        let daysComponents = Set([Calendar.Component.day])
        let components = Calendar.current.dateComponents(daysComponents, from: first, to: second)

        return components.day!
    }

}
