import ComponentBase
import Foundation

public class FakeShortFormDateFormatter: ShortFormDateFormatter {
    
    public init() {
        
    }

    public func dateString(from date: Date) -> String {
        return "Short Form | \(date.description)"
    }

}
