import EventsWidgetLogic

struct StubEventsRepository: EventRepository {
    
    var events: [Event]
    
    func loadEvents(completionHandler: @escaping ([Event]) -> Void) {
        completionHandler(events)
    }
    
}
