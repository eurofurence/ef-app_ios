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
    
    public func event(at index: Int) -> EventViewModel {
        EventViewModelAdapter(event: events[index], timestampFormatter: formatters.eventTimestamps)
    }
    
    private struct EventViewModelAdapter: EventViewModel {
        
        var event: Event
        var timestampFormatter: DateFormatterProtocol
        
        var name: String {
            event.title
        }
        
        var location: String {
            event.room.name
        }
        
        var startTime: String {
            timestampFormatter.string(from: event.startDate)
        }
        
        var endTime: String {
            timestampFormatter.string(from: event.endDate)
        }
        
        var isFavourite: Bool {
            event.isFavourite
        }
        
        var isSponsorOnly: Bool {
            event.isSponsorOnly
        }
        
        var isSuperSponsorOnly: Bool {
            event.isSuperSponsorOnly
        }
        
        var isArtShow: Bool {
            event.isArtShow
        }
        
        var isKageEvent: Bool {
            event.isKageEvent
        }
        
        var isDealersDen: Bool {
            event.isDealersDen
        }
        
        var isMainStage: Bool {
            event.isMainStage
        }
        
        var isPhotoshoot: Bool {
            event.isPhotoshoot
        }

    }
    
}
