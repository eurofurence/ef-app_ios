import EventsWidgetLogic
import XCTest

class EventsTimelineControllerTests: XCTestCase {
    
    func testOneEvent() throws {
        let context = EventWidgetContext.large
        let event = StubEvent(id: "some_event", title: "Some Event")
        let repository = StubEventsRepository(events: [event])
        let controller = EventsTimelineController(context: context, repository: repository)
        var actual: [EventTimelineEntry]?
        controller.makeEntries(completionHandler: { actual = $0 })
        
        let expected: [EventTimelineEntry] = [
            EventTimelineEntry(events: [
                EventViewModel(id: "some_event", title: "Some Event")
            ], additionalEventsCount: 0)
        ]
        
        XCTAssertEqual(expected, actual)
    }
    
}
