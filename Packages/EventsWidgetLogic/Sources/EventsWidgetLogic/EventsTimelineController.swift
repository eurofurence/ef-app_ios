import Foundation.NSDate

public struct EventsTimelineController {
    
    private let repository: EventRepository
    
    public init(repository: EventRepository) {
        self.repository = repository
    }
    
}

// MARK: - Snapshot

extension EventsTimelineController {
    
    public struct SnapshotOptions {
        
        let maximumEventsPerEntry: Int
        let snapshottingAtTime: Date
        
        public init(maximumEventsPerEntry: Int, snapshottingAtTime: Date) {
            self.maximumEventsPerEntry = maximumEventsPerEntry
            self.snapshottingAtTime = snapshottingAtTime
        }
        
    }
    
    public func makeSnapshotEntry(options: SnapshotOptions, completionHandler: @escaping (EventTimelineEntry) -> Void) {
        repository.loadEvents { (events) in
            let eventsRelevantForSnapshot = events.filter({ $0.startTime >= options.snapshottingAtTime }).sorted(by: \.title)
            let reducedEventsListingForSnapshot = eventsRelevantForSnapshot.prefix(options.maximumEventsPerEntry)
            let additionalEvents = eventsRelevantForSnapshot.count - reducedEventsListingForSnapshot.count
            let viewModels = reducedEventsListingForSnapshot.map(EventViewModel.init(event:))
            let entry = EventTimelineEntry(date: options.snapshottingAtTime, events: viewModels, additionalEventsCount: additionalEvents)
            completionHandler(entry)
        }
    }
    
}

// MARK: - Timeline

extension EventsTimelineController {
    
    public struct TimelineOptions {
        
        let maximumEventsPerEntry: Int
        let timelineStartDate: Date
        
        public init(maximumEventsPerEntry: Int, timelineStartDate: Date) {
            self.maximumEventsPerEntry = maximumEventsPerEntry
            self.timelineStartDate = timelineStartDate
        }
        
    }
    
    public func makeEntries(options: TimelineOptions, completionHandler: @escaping ([EventTimelineEntry]) -> Void) {
        ClusterEventsIntoEntriesTask(
            repository: repository,
            maximumEventsPerEntry: options.maximumEventsPerEntry,
            timelineStartDate: options.timelineStartDate,
            completionHandler: completionHandler
        ).beginClustering()
    }
    
}
