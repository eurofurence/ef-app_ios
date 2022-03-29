import Combine
import ComponentBase
import EurofurenceModel

public class EventsWidgetViewModel {
    
    public var numberOfEvents: Int {
        events.count
    }
    
    private let formatters: Formatters
    private var subscriptions = Set<AnyCancellable>()
    private var events = [Event]()
    
    public struct Formatters {
        
        var eventTimestamps: DateFormatterProtocol
        
        public init() {
            self.eventTimestamps = {
                let formatter = EurofurenceDateFormatter()
                formatter.dateStyle = .none
                formatter.timeStyle = .short
                
                return formatter
            }()
        }
        
        public init(eventTimestamps: DateFormatterProtocol) {
            self.eventTimestamps = eventTimestamps
        }
        
    }
    
    public convenience init<T>(interactor: T) where T: EventsWidgetDataSource {
        self.init(interactor: interactor, formatters: Formatters())
    }
    
    public init<T>(interactor: T, formatters: Formatters) where T: EventsWidgetDataSource {
        self.formatters = formatters
        
        interactor
            .events
            .sink { [weak self] (events) in
                self?.events = events
            }
            .store(in: &subscriptions)
    }
    
    public func event(at index: Int) -> EventViewModelAdapter {
        EventViewModelAdapter(event: events[index], timestampFormatter: formatters.eventTimestamps)
    }
    
}

public class EventViewModelAdapter: EventViewModel, EventObserver {
    
    private let event: Event
    private let timestampFormatter: DateFormatterProtocol
    
    init(event: Event, timestampFormatter: DateFormatterProtocol) {
        self.event = event
        self.timestampFormatter = timestampFormatter
        
        event.add(self)
    }
    
    public func eventDidBecomeFavourite(_ event: Event) {
        objectDidChange.send()
    }
    
    public func eventDidBecomeUnfavourite(_ event: Event) {
        objectDidChange.send()
    }
    
    public var name: String {
        event.title
    }
    
    public var location: String {
        event.room.name
    }
    
    public var startTime: String {
        timestampFormatter.string(from: event.startDate)
    }
    
    public var endTime: String {
        timestampFormatter.string(from: event.endDate)
    }
    
    public var isFavourite: Bool {
        event.isFavourite
    }
    
    public var isSponsorOnly: Bool {
        event.isSponsorOnly
    }
    
    public var isSuperSponsorOnly: Bool {
        event.isSuperSponsorOnly
    }
    
    public var isArtShow: Bool {
        event.isArtShow
    }
    
    public var isKageEvent: Bool {
        event.isKageEvent
    }
    
    public var isDealersDen: Bool {
        event.isDealersDen
    }
    
    public var isMainStage: Bool {
        event.isMainStage
    }
    
    public var isPhotoshoot: Bool {
        event.isPhotoshoot
    }

}
