import Eurofurence
import EurofurenceModel
import Foundation

class FakeDateRangeFormatter: DateRangeFormatter {

    private struct Input: Hashable {
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(start)
            hasher.combine(end)
        }

        static func == (lhs: FakeDateRangeFormatter.Input, rhs: FakeDateRangeFormatter.Input) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }

        var start: Date
        var end: Date
    }

    private var strings = [Input: String]()
    func string(from startDate: Date, to endDate: Date) -> String {
        let input = Input(start: startDate, end: endDate)
        var string: String
        if let str = strings[input] {
            string = str
        } else {
            string = .random
        }

        strings[input] = string

        return string
    }

}
