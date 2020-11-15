import Foundation.NSDate

public struct EventsTimelineController {
    
    private let repository: EventRepository
    private let options: Options
    
    public struct Options {
        
        let maximumEventsPerEntry: Int
        let timelineStartDate: Date
        
        public init(maximumEventsPerEntry: Int, timelineStartDate: Date) {
            self.maximumEventsPerEntry = maximumEventsPerEntry
            self.timelineStartDate = timelineStartDate
        }
        
    }
    
    public init(repository: EventRepository, options: Options) {
        self.repository = repository
        self.options = options
    }
    
    public func makeEntries(completionHandler: @escaping ([EventTimelineEntry]) -> Void) {
        repository.loadEvents { (events) in
            let eventClusters = EventClusterFactory(
                events: events,
                timelineStartDate: options.timelineStartDate,
                maximumEventsPerCluster: options.maximumEventsPerEntry
            ).makeClusters()
            
            let entries = eventClusters.map(EventTimelineEntry.init(cluster:))
            
            completionHandler(entries)
        }
    }
    
}
