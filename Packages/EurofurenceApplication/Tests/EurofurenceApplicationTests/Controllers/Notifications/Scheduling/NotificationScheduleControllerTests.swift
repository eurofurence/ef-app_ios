import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class NotificationScheduleControllerTests: XCTestCase {
    
    var controller: NotificationScheduleController!
    var notificationScheduler: CapturingNotificationScheduler!
    var upcomingEventReminderInterval: TimeInterval!
    var hoursDateFormatter: FakeHoursDateFormatter!
    var eventToFavourite: Event!
    var clock: StubClock!
    
    override func setUp() {
        super.setUp()
        
        let eventsService = FakeEventsService()
        let events = [FakeEvent].random
        eventsService.allEvents = events
        notificationScheduler = CapturingNotificationScheduler()
        hoursDateFormatter = FakeHoursDateFormatter()
        upcomingEventReminderInterval = TimeInterval.random
        clock = StubClock(currentDate: .distantPast)
        controller = NotificationScheduleController(
            eventsService: eventsService,
            notificationScheduler: notificationScheduler,
            hoursDateFormatter: hoursDateFormatter,
            upcomingEventReminderInterval: upcomingEventReminderInterval,
            clock: clock
        )
        
        eventToFavourite = events.randomElement().element
    }

    func testFavouritingEventSchedulesNotification() {
        eventToFavourite.favourite()
        
        let expectedDateComponents: DateComponents = {
            let scheduleTime = eventToFavourite.startDate.addingTimeInterval(-upcomingEventReminderInterval)
            let components: Set<Calendar.Component> = Set([.calendar, .timeZone, .year, .month, .day, .hour, .minute])
            
            return Calendar.current.dateComponents(components, from: scheduleTime)
        }()
        
        let expectedTitle = eventToFavourite.title
        
        let expectedBody: String = {
            let expectedTimeString = hoursDateFormatter.hoursString(from: eventToFavourite.startDate)
            return String.eventReminderBody(timeString: expectedTimeString, roomName: eventToFavourite.room.name)
        }()
        
        let expectedUserInfo: [ApplicationNotificationKey: String] =
            [.notificationContentKind: ApplicationNotificationContentKind.event.rawValue,
             .notificationContentIdentifier: eventToFavourite.identifier.rawValue]
        
        XCTAssertEqual(eventToFavourite.identifier, notificationScheduler.capturedEventIdentifier)
        XCTAssertEqual(expectedDateComponents, notificationScheduler.capturedEventNotificationScheduledDateComponents)
        XCTAssertEqual(expectedTitle, notificationScheduler.capturedEventNotificationTitle)
        XCTAssertEqual(expectedBody, notificationScheduler.capturedEventNotificationBody)
        XCTAssertEqual(expectedUserInfo, notificationScheduler.capturedEventNotificationUserInfo)
    }
    
    func testUnfavouritingEventCancelsNotification() {
        eventToFavourite.favourite()
        eventToFavourite.unfavourite()
        
        XCTAssertEqual(eventToFavourite.identifier, notificationScheduler.capturedEventIdentifierToRemoveNotification)
    }
    
    func testFavouritingEventThatHasAlreadyHappenedDoesNotScheduleNotification() {
        let eventStartTime = eventToFavourite.startDate
        let someTimeAfterStartTime = eventStartTime.addingTimeInterval(60)
        clock.tickTime(to: someTimeAfterStartTime)
        eventToFavourite.favourite()
        
        XCTAssertNil(notificationScheduler.capturedEventIdentifier)
    }

}
