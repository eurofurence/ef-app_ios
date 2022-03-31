public protocol EventsWidgetViewModel {
    
    associatedtype Event: EventViewModel
    
    var title: String { get }
    var numberOfEvents: Int { get }
    
    func event(at index: Int) -> Event
    
}
