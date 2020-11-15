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
        ClusterEventsIntoEntriesTask(
            repository: repository,
            maximumEventsPerEntry: options.maximumEventsPerEntry,
            timelineStartDate: options.timelineStartDate,
            completionHandler: completionHandler
        ).beginClustering()
    }
    
}
