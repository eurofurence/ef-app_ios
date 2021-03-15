import Foundation

public class EurofurenceDateIntervalFormatter: DateIntervalFormatter {
    
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
