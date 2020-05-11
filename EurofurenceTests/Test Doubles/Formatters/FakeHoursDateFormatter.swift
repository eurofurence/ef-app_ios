import Eurofurence
import TestUtilities

class FakeHoursDateFormatter: HoursDateFormatter {

    private var strings = [Date: String]()
    
    func stub(_ hoursString: String, for date: Date) {
        strings[date] = hoursString
    }

    func hoursString(from date: Date) -> String {
        var output = String.random
        if let previous = strings[date] {
            output = previous
        } else {
            strings[date] = output
        }

        return output
    }

}
