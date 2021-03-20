import ComponentBase
import Foundation

public class FakeShortFormDayAndTimeFormatter: ShortFormDayAndTimeFormatter {

    private var strings = [Date: String]()
    
    public init() {
        
    }

    public func dayAndHoursString(from date: Date) -> String {
        var output = String.random
        if let previous = strings[date] {
            output = previous
        } else {
            strings[date] = output
        }

        return output
    }

}
