import Combine
import ComponentBase
import EurofurenceModel

public class DataSourceBackedEventsWidgetViewModel: EventsWidgetViewModel {
    
    public typealias Event = EventViewModelAdapter
    
    public let title: String
    
    public var numberOfEvents: Int {
        events.count
    }
    
    private let formatters: Formatters
    private var subscriptions = Set<AnyCancellable>()
    private var events = [EurofurenceModel.Event]()
    
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
    
    public convenience init<T>(
        interactor: T,
        description: String
    ) where T: EventsWidgetDataSource {
        self.init(interactor: interactor, formatters: Formatters(), description: description)
    }
    
    public init<T>(
        interactor: T,
        formatters: Formatters,
        description: String
    ) where T: EventsWidgetDataSource {
        self.formatters = formatters
        self.title = description
        
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

public class EventViewModelAdapter: EventViewModel {
    
    private let event: Event
    private let timestampFormatter: DateFormatterProtocol
    private var changeNotifier: NotifyObjectChangedWhenEventChanges!
    
    init(event: Event, timestampFormatter: DateFormatterProtocol) {
        self.event = event
        self.timestampFormatter = timestampFormatter
        self.changeNotifier = NotifyObjectChangedWhenEventChanges(adapter: self)
        
        event.add(changeNotifier)
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
    
    private class NotifyObjectChangedWhenEventChanges: EventObserver {
        
        private unowned let adapter: EventViewModelAdapter
        
        init(adapter: EventViewModelAdapter) {
            self.adapter = adapter
        }
        
        func eventDidBecomeFavourite(_ event: Event) {
            adapter.notifyObjectDidChange()
        }
        
        func eventDidBecomeUnfavourite(_ event: Event) {
            adapter.notifyObjectDidChange()
        }
        
    }
    
    private func notifyObjectDidChange() {
        objectDidChange.send()
    }

}
