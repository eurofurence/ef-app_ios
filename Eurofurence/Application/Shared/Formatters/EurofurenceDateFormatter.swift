import Foundation

class EurofurenceDateFormatter: DateFormatter {
    
    override init() {
        super.init()
        useConventionTimeZone()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        useConventionTimeZone()
    }
    
    private func useConventionTimeZone() {
        timeZone = TimeZone(identifier: "Europe/Berlin")
    }
    
}
