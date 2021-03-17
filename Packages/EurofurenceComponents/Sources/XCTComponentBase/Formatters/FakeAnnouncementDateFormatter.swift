import ComponentBase
import Foundation
import TestUtilities

public class FakeAnnouncementDateFormatter: AnnouncementDateFormatter {

    private var strings = [Date: String]()
    
    public init() {
        
    }

    public func string(from date: Date) -> String {
        var output = String.random
        if let previous = strings[date] {
            output = previous
        } else {
            strings[date] = output
        }

        return output
    }

}
