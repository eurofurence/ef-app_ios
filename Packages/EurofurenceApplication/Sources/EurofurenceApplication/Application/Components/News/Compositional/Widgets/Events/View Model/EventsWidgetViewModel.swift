import ObservedObject

public protocol EventsWidgetViewModel: ObservedObject {
    
    associatedtype Event: EventViewModel
    
    var title: String { get }
    var numberOfEvents: Int { get }
    
    func event(at index: Int) -> Event
    
}
