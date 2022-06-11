import Foundation.NSDate

public struct EventsTimelineController {
    
    private let repository: EventRepository
    private let filteringPolicy: TimelineEntryFilteringPolicy
    private let viewModelFactory: EventViewModelFactory
    
    public init(
        repository: EventRepository,
        filteringPolicy: TimelineEntryFilteringPolicy,
        eventTimeFormatter: EventTimeFormatter,
        accessibilityFormatter: EventTimeFormatter
    ) {
        self.repository = repository
        self.filteringPolicy = filteringPolicy
        viewModelFactory = EventViewModelFactory(
            eventTimeFormatter: eventTimeFormatter,
            accessibilityFormatter: accessibilityFormatter
        )
    }
    
}

// MARK: - Timeline

extension EventsTimelineController {
    
    public struct TimelineOptions {
        
        let maximumEventsPerEntry: Int
        let timelineStartDate: Date
        let eventCategory: EventCategory
        let isFavouritesOnly: Bool
        
        public init(
            maximumEventsPerEntry: Int,
            timelineStartDate: Date,
            eventCategory: EventCategory,
            isFavouritesOnly: Bool
        ) {
            self.maximumEventsPerEntry = maximumEventsPerEntry
            self.timelineStartDate = timelineStartDate
            self.eventCategory = eventCategory
            self.isFavouritesOnly = isFavouritesOnly
        }
        
    }
    
    public func makeTimeline(options: TimelineOptions, completionHandler: @escaping (EventsTimeline) -> Void) {
        ResolveTimelineEntriesTask(
            repository: repository,
            filteringPolicy: filteringPolicy,
            eventCategory: options.eventCategory,
            isFavouritesOnly: options.isFavouritesOnly,
            maximumEventsPerEntry: options.maximumEventsPerEntry,
            timelineStartDate: options.timelineStartDate,
            viewModelFactory: viewModelFactory,
            completionHandler: completionHandler
        ).resolveEntries()
    }
    
}
