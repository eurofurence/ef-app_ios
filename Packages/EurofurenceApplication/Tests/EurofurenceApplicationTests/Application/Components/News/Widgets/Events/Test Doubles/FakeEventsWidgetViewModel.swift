import EurofurenceApplication

class FakeEventsWidgetViewModel: EventsWidgetViewModel {
    
    typealias Event = FakeEventViewModel
    
    var title: String = ""
    
    var numberOfEvents: Int {
        events.count
    }
    
    var events: [FakeEventViewModel] = []
    
    func event(at index: Int) -> Event {
        events[index]
    }
    
    private(set) var selectedEventIndex: Int?
    func eventSelected(at index: Int) {
        selectedEventIndex = index
    }
    
}
