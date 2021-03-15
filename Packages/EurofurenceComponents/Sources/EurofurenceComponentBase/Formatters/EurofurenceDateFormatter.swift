import Foundation

public class EurofurenceDateFormatter: DateFormatter {
    
    override public init() {
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
