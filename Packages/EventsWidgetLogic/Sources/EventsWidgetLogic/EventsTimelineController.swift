import Foundation

public struct EventsTimelineController {
    
    private let repository: EventRepository
    
    public init(context: EventWidgetContext, repository: EventRepository) {
        self.repository = repository
    }
    
    public func makeEntries(completionHandler: @escaping ([EventTimelineEntry]) -> Void) {
        repository.loadEvents { (events) in
            let distinctStartTimes = Set(events.map(\.startTime)).sorted()
            
            var eventClusters = [[Event]]()
            for startTime in distinctStartTimes {
                let eventsOnOrAfterTime = events.filter({ $0.startTime >= startTime })
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
