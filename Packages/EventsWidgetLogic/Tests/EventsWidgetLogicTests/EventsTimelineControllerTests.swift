import EventsWidgetLogic
import XCTest

class EventsTimelineControllerTests: XCTestCase {
    
    func testOneEvent() throws {
        let now = Date()
        let event = StubEvent(id: "some_event", title: "Some Event", startTime: now)
        let repository = StubEventsRepository(events: [event])
        let controller = EventsTimelineController(repository: repository)
        
        var actual: [EventTimelineEntry]?
        controller.makeEntries(
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: now),
            completionHandler: { actual = $0 }
        )
        
        let expected: [EventTimelineEntry] = [
            EventTimelineEntry(
                date: now,
                events: [
                    EventViewModel(id: "some_event", title: "Some Event")
                ],
                additionalEventsCount: 0
            )
        ]
        
        XCTAssertEqual(expected, actual)
    }
    
    func testTwoEvents_StaggeredStartTimesYieldsTwoEntries() {
        let now = Date()
        let inHalfAnHour = now.addingTimeInterval(3600 / 2)
        let earlierEvent = StubEvent(id: "some_event", title: "Some Event", startTime: now)
        let laterEvent = StubEvent(id: "some_other_event", title: "Some Other Event", startTime: inHalfAnHour)
        let repository = StubEventsRepository(events: [earlierEvent, laterEvent])
        let controller = EventsTimelineController(repository: repository)
        
        var actual: [EventTimelineEntry]?
        controller.makeEntries(
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: now),
            completionHandler: { actual = $0 }
        )
        
        let expected: [EventTimelineEntry] = [
            EventTimelineEntry(
                date: now,
                events: [
                    EventViewModel(id: "some_event", title: "Some Event"),
                    EventViewModel(id: "some_other_event", title: "Some Other Event")
                ], additionalEventsCount: 0
            ),
            
            EventTimelineEntry(
                date: inHalfAnHour,
                events: [
                    EventViewModel(id: "some_other_event", title: "Some Other Event")
                ], additionalEventsCount: 0
            )
        ]
        
        XCTAssertEqual(expected, actual)
    }
    
    func testTwoEvents_StartingTimelineFromLaterDate() {
        let now = Date()
        let inHalfAnHour = now.addingTimeInterval(3600 / 2)
        let earlierEvent = StubEvent(id: "some_event", title: "Some Event", startTime: now)
        let laterEvent = StubEvent(id: "some_other_event", title: "Some Other Event", startTime: inHalfAnHour)
        let repository = StubEventsRepository(events: [earlierEvent, laterEvent])
        let controller = EventsTimelineController(repository: repository)
        
        var actual: [EventTimelineEntry]?
        controller.makeEntries(
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: inHalfAnHour),
            completionHandler: { actual = $0 }
        )
        
        let expected: [EventTimelineEntry] = [
            EventTimelineEntry(
                date: inHalfAnHour,
                events: [
                    EventViewModel(id: "some_other_event", title: "Some Other Event")
                ], additionalEventsCount: 0
            )
        ]
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSortsEventsWithinEntryByName() {
        let now = Date()
        let events = [
            StubEvent(id: "2", title: "B Event", startTime: now),
            StubEvent(id: "3", title: "C Event", startTime: now),
            StubEvent(id: "1", title: "A Event", startTime: now)
        ]
        
        let repository = StubEventsRepository(events: events)
        let controller = EventsTimelineController(repository: repository)
        
        var actual: [EventTimelineEntry]?
        controller.makeEntries(
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: now),
            completionHandler: { actual = $0 }
        )
        
        let expected: [EventTimelineEntry] = [
            EventTimelineEntry(
                date: now,
                events: [
                    EventViewModel(id: "1", title: "A Event"),
                    EventViewModel(id: "2", title: "B Event"),
                    EventViewModel(id: "3", title: "C Event")
                ], additionalEventsCount: 0
            )
        ]
        
        XCTAssertEqual(expected, actual)
    }
    
    func testExceedingEventsWithinGroupDropsLastEvents() {
        let now = Date()
        let events = [
            StubEvent(id: "2", title: "B Event", startTime: now),
            StubEvent(id: "3", title: "C Event", startTime: now),
            StubEvent(id: "1", title: "A Event", startTime: now),
            StubEvent(id: "5", title: "E Event", startTime: now),
            StubEvent(id: "4", title: "D Event", startTime: now)
        ]
        
        let repository = StubEventsRepository(events: events)
        let controller = EventsTimelineController(repository: repository)
        
        var actual: [EventTimelineEntry]?
        controller.makeEntries(
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: now),
            completionHandler: { actual = $0 }
        )
        
        let expected: [EventTimelineEntry] = [
            EventTimelineEntry(
                date: now,
                events: [
                    EventViewModel(id: "1", title: "A Event"),
                    EventViewModel(id: "2", title: "B Event"),
                    EventViewModel(id: "3", title: "C Event")
                ], additionalEventsCount: 2
            )
        ]
        
        XCTAssertEqual(expected, actual)
    }
    
}
