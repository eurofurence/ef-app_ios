import Foundation.NSDate

public protocol TimelineEntryFilteringPolicy {
    
    func filterEvents(_ events: [Event], inGroupStartingAt startTime: Date) -> [Event]
    
}
