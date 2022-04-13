import EurofurenceApplication
import Foundation

class FakeDateFormatter: DateFormatterProtocol {
    
    private var stubs = [Date: String]()
    
    func stub(_ string: String, for date: Date) {
        stubs[date] = string
    }
    
    func string(from date: Date) -> String {
        stubs[date, default: "UNSET"]
    }
    
}
