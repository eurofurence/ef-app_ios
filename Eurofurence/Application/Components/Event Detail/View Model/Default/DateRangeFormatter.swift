import Foundation

public protocol DateRangeFormatter {

    func string(from startDate: Date, to endDate: Date) -> String

}
