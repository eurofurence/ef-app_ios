import Foundation

public struct EventsTimelineController {
    
    private let repository: EventRepository
    
    public init(context: EventWidgetContext, repository: EventRepository) {
        self.repository = repository
    }
    
    public func makeEntries(completionHandler: @escaping ([EventTimelineEntry]) -> Void) {
        repository.loadEvents { (events) in
            let groups = Dictionary(grouping: events, by: \.startTime)
            let groupsSortedByTime = groups.sorted(by: { (first, second) -> Bool in
                first.key < second.key
            })
            
            var eventClusters = [[Event]]()
            for (groupStartTime, _) in groupsSortedByTime {
                let eventsOnOrAfterTime = events.filter({ $0.startTime >= groupStartTime })
                eventClusters.append(eventsOnOrAfterTime)
            }
            
            var entries = [EventTimelineEntry]()
            for cluster in eventClusters {
                guard let firstInCluster = cluster.first else { continue }
                let entry = makeTimelineEntry(events: cluster, relevantDate: firstInCluster.startTime)
                entries.append(entry)
            }
            
            completionHandler(entries)
        }
    }
    
    private func makeTimelineEntry(events: [Event], relevantDate: Date) -> EventTimelineEntry {
        let viewModels = events.map(EventViewModel.init)
        let entry = EventTimelineEntry(date: relevantDate, events: viewModels, additionalEventsCount: 0)
        
        return entry
    }
    
}
