import Foundation.NSDate

public protocol EventTimeFormatter {
    
    func string(from date: Date) -> String
    
}
