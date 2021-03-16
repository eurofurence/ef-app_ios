import EurofurenceComponentBase
import Foundation
import TestUtilities

public class FakeHoursDateFormatter: HoursDateFormatter {

    private var strings = [Date: String]()
    
    public init() {
        
    }
    
    public func stub(_ hoursString: String, for date: Date) {
        strings[date] = hoursString
    }

    public func hoursString(from date: Date) -> String {
        var output = String.random
        if let previous = strings[date] {
            output = previous
        } else {
            strings[date] = output
        }

        return output
    }

}
