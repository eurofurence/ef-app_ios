import Combine
import EurofurenceModel

public struct FilteredScheduleWidgetDataSource<S>: EventsWidgetDataSource where S: Specification, S.Element == Event {
    
    private let schedule: Schedule
    
    public let events = CurrentValueSubject<[Event], Never>([])
    
    public init(repository: ScheduleRepository, specification: S) {
        schedule = repository.loadSchedule(tag: "Events Widget (\(String(describing: S.self))")
        schedule.filterSchedule(to: specification)
        schedule.setDelegate(UpdatePipelineWhenScheduleChanges(pipeline: events))
    }
    
    private struct UpdatePipelineWhenScheduleChanges: ScheduleDelegate {
        
        var pipeline: CurrentValueSubject<[Event], Never>
        
        func scheduleEventsDidChange(to events: [Event]) {
            pipeline.send(events)
        }
        
        func eventDaysDidChange(to days: [Day]) {
            
        }
        
        func currentEventDayDidChange(to day: Day?) {
            
        }
        
        func scheduleSpecificationChanged(to newSpecification: AnySpecification<Event>) {
            
        }
        
    }
    
}
