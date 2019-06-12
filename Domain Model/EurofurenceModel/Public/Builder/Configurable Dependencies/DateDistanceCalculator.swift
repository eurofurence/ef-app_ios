import Foundation

public protocol DateDistanceCalculator {

    func calculateDays(between first: Date, and second: Date) -> Int

}
