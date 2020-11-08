public struct EventsTimelineController {
    
    private let repository: EventRepository
    
    public init(context: EventWidgetContext, repository: EventRepository) {
        self.repository = repository
    }
    
    public func makeEntries(completionHandler: @escaping ([EventTimelineEntry]) -> Void) {
        repository.loadEvents { (events) in
            let viewModels = events.map(EventViewModel.init)
            let entry = EventTimelineEntry(events: viewModels, additionalEventsCount: 0)
            completionHandler([entry])
        }
    }
    
}
