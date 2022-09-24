import EventKit
import Logging

public class EventKitCalendar: EventCalendar {
    
    public static let shared = EventKitCalendar()
    private let logger = Logger(label: "EventKitCalendar")
    private var eventStoreChangedSubscription: NSObjectProtocol?
    
    private let eventStore: EKEventStore
    public let calendarChanged = EventCalendarChangedPublisher()
    
    private init() {
        self.eventStore = EKEventStore()
        eventStoreChangedSubscription = NotificationCenter.default.addObserver(
            forName: .EKEventStoreChanged,
            object: eventStore,
            queue: .main,
            using: { [unowned self] _ in
                calendarChanged.send(self)
            })
    }
    
    public func add(entry: EventCalendarEntry) {
        attemptCalendarStoreEdit { [unowned self] in
            let calendarEvent = EKEvent(eventStore: eventStore)
            calendarEvent.calendar = eventStore.defaultCalendarForNewEvents
            calendarEvent.title = entry.title
            calendarEvent.location = entry.location
            calendarEvent.startDate = entry.startDate
            calendarEvent.endDate = entry.endDate
            calendarEvent.url = entry.url
            calendarEvent.notes = entry.shortDescription
            calendarEvent.addAlarm(EKAlarm(relativeOffset: -1800))
            
            do {
                try eventStore.save(calendarEvent, span: .thisEvent)
            } catch {
                logger.error("Failed to add calendar event", metadata: ["Error": .string(String(describing: error))])
            }
        }
    }
    
    public func remove(entry: EventCalendarEntry) {
        attemptCalendarStoreEdit { [unowned self] in
            if let event = eventKitEvent(for: entry) {
                do {
                    try eventStore.remove(event, span: .thisEvent)
                } catch {
                    logger.error("Failed to add remove event", metadata: ["Error": .string(String(describing: error))])
                }
            }
        }
    }
    
    public func contains(entry: EventCalendarEntry) -> Bool {
        eventKitEvent(for: entry) != nil
    }
    
    private func eventKitEvent(for entry: EventCalendarEntry) -> EKEvent? {
        let predicate = eventStore.predicateForEvents(withStart: entry.startDate, end: entry.endDate, calendars: nil)
        let events = eventStore.events(matching: predicate)
        let event = events.first(where: { $0.url == entry.url })
        
        return event
    }
    
    private func attemptCalendarStoreEdit(edit: @escaping () -> Void) {
        if EKEventStore.authorizationStatus(for: .event) == .authorized {
            edit()
        } else {
            requestCalendarEditingAuthorisation(success: edit)
        }
    }
    
    private func requestCalendarEditingAuthorisation(success: @escaping () -> Void) {
        eventStore.requestAccess(to: .event) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    success()
                }
            }
        }
    }
    
}
