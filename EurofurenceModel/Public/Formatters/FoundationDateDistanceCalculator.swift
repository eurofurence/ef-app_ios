import Foundation

public struct FoundationDateDistanceCalculator: DateDistanceCalculator {

    public init() {

    }

    public func calculateDays(between first: Date, and second: Date) -> Int {
        let daysComponents = Set([Calendar.Component.day])
        let components = Calendar.current.dateComponents(daysComponents, from: first, to: second)
        
        guard let day = components.day else {
            fatalError("Day not calculated from Calendar as expected - are the input dates valid? (\(first) -> \(second))")
        }

        return day
    }

}
