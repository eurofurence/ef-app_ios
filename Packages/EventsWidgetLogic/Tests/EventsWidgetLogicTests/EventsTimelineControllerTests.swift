import EventsWidgetLogic
import XCTest

class EventsTimelineControllerTests: XCTestCase {
    
    func testOneEvent() throws {
        let context = EventWidgetContext.large
        let now = Date()
        let event = StubEvent(id: "some_event", title: "Some Event", startTime: now)
        let repository = StubEventsRepository(events: [event])
        let controller = EventsTimelineController(context: context, repository: repository)
        var actual: [EventTimelineEntry]?
        controller.makeEntries(completionHandler: { actual = $0 })
        
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
        let context = EventWidgetContext.large
        let now = Date()
        let inHalfAnHour = now.addingTimeInterval(3600 / 2)
        let earlierEvent = StubEvent(id: "some_event", title: "Some Event", startTime: now)
        let laterEvent = StubEvent(id: "some_other_event", title: "Some Other Event", startTime: inHalfAnHour)
        let repository = StubEventsRepository(events: [earlierEvent, laterEvent])
        let controller = EventsTimelineController(context: context, repository: repository)
        var actual: [EventTimelineEntry]?
        controller.makeEntries(completionHandler: { actual = $0 })
        
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
    
}
