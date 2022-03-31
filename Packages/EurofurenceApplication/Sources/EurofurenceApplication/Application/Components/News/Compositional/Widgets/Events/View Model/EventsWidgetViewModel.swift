public protocol EventsWidgetViewModel {
    
    associatedtype Event: EventViewModel
    
    var numberOfEvents: Int { get }
    
    func event(at index: Int) -> Event
    
}
