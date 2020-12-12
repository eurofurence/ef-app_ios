import Foundation

public struct UpcomingEventRule: Rule {
    
    private let clock: Clock
    private let configuration: UpcomingEventConfiguration
    
    public init(clock: Clock, configuration: UpcomingEventConfiguration) {
        self.clock = clock
        self.configuration = configuration
    }
    
    public func isSatisfied(by event: Event) -> Bool {
        let now = clock.currentDate
        let endOfUpcomingPeriod = now.addingTimeInterval(configuration.intervalFromPresentForUpcomingEvents)
        let upcomingPeriod = DateInterval(start: now, end: endOfUpcomingPeriod)
        
        return upcomingPeriod.contains(event.startDate)
    }
    
}

public protocol UpcomingEventConfiguration {
    
    var intervalFromPresentForUpcomingEvents: TimeInterval { get }
    
}
