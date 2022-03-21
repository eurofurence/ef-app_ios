import ComponentBase
import EurofurenceModel
import Foundation

public class NotificationScheduleController: ScheduleRepositoryObserver {
    
    private class ScheduleNotificationWhenEventFavourited: EventObserver {
        
        private unowned let controller: NotificationScheduleController
        
        init(controller: NotificationScheduleController) {
            self.controller = controller
        }
        
        func eventDidBecomeFavourite(_ event: Event) {
            controller.scheduleNotification(for: event)
        }
        
        func eventDidBecomeUnfavourite(_ event: Event) {
            controller.cancelNotification(for: event)
        }
        
    }
    
    private lazy var favouritesObserver = ScheduleNotificationWhenEventFavourited(controller: self)
    private let notificationScheduler: NotificationScheduler
    private let hoursDateFormatter: HoursDateFormatter
    private let upcomingEventReminderInterval: TimeInterval
    private let clock: Clock
    
    public init(
        eventsService: ScheduleRepository,
        notificationScheduler: NotificationScheduler,
        hoursDateFormatter: HoursDateFormatter,
        upcomingEventReminderInterval: TimeInterval,
        clock: Clock
    ) {
        self.notificationScheduler = notificationScheduler
        self.hoursDateFormatter = hoursDateFormatter
        self.upcomingEventReminderInterval = upcomingEventReminderInterval
        self.clock = clock
        
        eventsService.add(self)
    }
    
    public func eventsDidChange(to events: [Event]) {
        events.forEach({ $0.add(favouritesObserver) })
    }
    
    public func runningEventsDidChange(to events: [Event]) { }
    public func upcomingEventsDidChange(to events: [Event]) { }
    public func favouriteEventsDidChange(_ identifiers: [EventIdentifier]) { }
    
    private func scheduleNotification(for event: Event) {
        let eventStartTime = event.startDate
        guard eventStartTime > clock.currentDate else { return }
        
        let waitInterval = upcomingEventReminderInterval * -1
        let reminderDate = eventStartTime.addingTimeInterval(waitInterval)
        let startTimeString = hoursDateFormatter.hoursString(from: eventStartTime)
        let body = String.eventReminderBody(timeString: startTimeString, roomName: event.room.name)
        
        let eventIdentifier = event.identifier
        let userInfo: [ApplicationNotificationKey: String] = [
            .notificationContentKind: ApplicationNotificationContentKind.event.rawValue,
            .notificationContentIdentifier: event.identifier.rawValue
        ]
        
        let components: DateComponents = {
            let desired: Set<Calendar.Component> = Set([.calendar, .timeZone, .year, .month, .day, .hour, .minute])
            return Calendar.current.dateComponents(desired, from: reminderDate)
        }()
        
        notificationScheduler.scheduleNotification(forEvent: eventIdentifier,
                                                   at: components,
                                                   title: event.title,
                                                   body: body,
                                                   userInfo: userInfo)
    }
    
    private func cancelNotification(for event: Event) {
        notificationScheduler.cancelNotification(forEvent: event.identifier)
    }
    
}
