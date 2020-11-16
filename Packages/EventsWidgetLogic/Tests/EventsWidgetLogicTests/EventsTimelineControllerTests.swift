import EventsWidgetLogic
import XCTest

class EventsTimelineControllerTests: XCTestCase {
    
    private var formatter: FakeEventTimeFormatter!
    private var controller: EventsTimelineController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        formatter = FakeEventTimeFormatter()
    }
    
    private func setUpController(repository: EventRepository) {
        controller = EventsTimelineController(repository: repository, eventTimeFormatter: formatter)
    }
    
    private func string(from date: Date) -> String {
        formatter.string(from: date)
    }
    
    // MARK: - Timeline Tests
    
    func testTimeline_OneEvent() throws {
        let now = Date()
        let event = StubEvent(id: "some_event", title: "Some Event", startTime: now)
        let repository = StubEventsRepository(events: [event])
        setUpController(repository: repository)
        
        var actual: [EventTimelineEntry]?
        controller.makeEntries(
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: now),
            completionHandler: { actual = $0 }
        )
        
        let expected: [EventTimelineEntry] = [
            EventTimelineEntry(
                date: now,
                events: [
                    EventViewModel(id: "some_event", title: "Some Event", formattedStartTime: string(from: now))
                ],
                additionalEventsCount: 0
            )
        ]
        
        XCTAssertEqual(expected, actual)
    }
    
    func testTimeline_TwoEvents_StaggeredStartTimesYieldsTwoEntries() {
        let now = Date()
        let inHalfAnHour = now.addingTimeInterval(3600 / 2)
        let earlierEvent = StubEvent(id: "some_event", title: "Some Event", startTime: now)
        let laterEvent = StubEvent(id: "some_other_event", title: "Some Other Event", startTime: inHalfAnHour)
        let repository = StubEventsRepository(events: [earlierEvent, laterEvent])
        setUpController(repository: repository)
        
        var actual: [EventTimelineEntry]?
        controller.makeEntries(
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: now),
            completionHandler: { actual = $0 }
        )
        
        let expected: [EventTimelineEntry] = [
            EventTimelineEntry(
                date: now,
                events: [
                    EventViewModel(
                        id: "some_event",
                        title: "Some Event",
                        formattedStartTime: string(from: now)
                    ),
                    
                    EventViewModel(
                        id: "some_other_event",
                        title: "Some Other Event",
                        formattedStartTime: string(from: inHalfAnHour)
                    )
                ], additionalEventsCount: 0
            ),
            
            EventTimelineEntry(
                date: inHalfAnHour,
                events: [
                    EventViewModel(
                        id: "some_other_event",
                        title: "Some Other Event",
                        formattedStartTime: string(from: inHalfAnHour)
                    )
                ], additionalEventsCount: 0
            )
        ]
        
        XCTAssertEqual(expected, actual)
    }
    
    func testTimeline_TwoEvents_StartingTimelineFromLaterDate() {
        let now = Date()
        let inHalfAnHour = now.addingTimeInterval(3600 / 2)
        let earlierEvent = StubEvent(id: "some_event", title: "Some Event", startTime: now)
        let laterEvent = StubEvent(id: "some_other_event", title: "Some Other Event", startTime: inHalfAnHour)
        let repository = StubEventsRepository(events: [earlierEvent, laterEvent])
        setUpController(repository: repository)
        
        var actual: [EventTimelineEntry]?
        controller.makeEntries(
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: inHalfAnHour),
            completionHandler: { actual = $0 }
        )
        
        let expected: [EventTimelineEntry] = [
            EventTimelineEntry(
                date: inHalfAnHour,
                events: [
                    EventViewModel(
                        id: "some_other_event",
                        title: "Some Other Event",
                        formattedStartTime: string(from: inHalfAnHour)
                    )
                ], additionalEventsCount: 0
            )
        ]
        
        XCTAssertEqual(expected, actual)
    }
    
    func testTimeline_SortsEventsWithinEntryByName() {
        let now = Date()
        let events = [
            StubEvent(id: "2", title: "B Event", startTime: now),
            StubEvent(id: "3", title: "C Event", startTime: now),
            StubEvent(id: "1", title: "A Event", startTime: now)
        ]
        
        let repository = StubEventsRepository(events: events)
        setUpController(repository: repository)
        
        var actual: [EventTimelineEntry]?
        controller.makeEntries(
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: now),
            completionHandler: { actual = $0 }
        )
        
        let expected: [EventTimelineEntry] = [
            EventTimelineEntry(
                date: now,
                events: [
                    EventViewModel(id: "1", title: "A Event", formattedStartTime: string(from: now)),
                    EventViewModel(id: "2", title: "B Event", formattedStartTime: string(from: now)),
                    EventViewModel(id: "3", title: "C Event", formattedStartTime: string(from: now))
                ], additionalEventsCount: 0
            )
        ]
        
        XCTAssertEqual(expected, actual)
    }
    
    func testTimeline_ExceedingEventsWithinGroupDropsLastEvents() {
        let now = Date()
        let events = [
            StubEvent(id: "2", title: "B Event", startTime: now),
            StubEvent(id: "3", title: "C Event", startTime: now),
            StubEvent(id: "1", title: "A Event", startTime: now),
            StubEvent(id: "5", title: "E Event", startTime: now),
            StubEvent(id: "4", title: "D Event", startTime: now)
        ]
        
        let repository = StubEventsRepository(events: events)
        setUpController(repository: repository)
        
        var actual: [EventTimelineEntry]?
        controller.makeEntries(
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: now),
            completionHandler: { actual = $0 }
        )
        
        let expected: [EventTimelineEntry] = [
            EventTimelineEntry(
                date: now,
                events: [
                    EventViewModel(id: "1", title: "A Event", formattedStartTime: string(from: now)),
                    EventViewModel(id: "2", title: "B Event", formattedStartTime: string(from: now)),
                    EventViewModel(id: "3", title: "C Event", formattedStartTime: string(from: now))
                ], additionalEventsCount: 2
            )
        ]
        
        XCTAssertEqual(expected, actual)
    }
    
    // MARK: - Snapshot Tests
    
    func testSnapshot_OneEvent() {
        let now = Date()
        let event = StubEvent(id: "some_event", title: "Some Event", startTime: now)
        let repository = StubEventsRepository(events: [event])
        setUpController(repository: repository)
        
        var actual: EventTimelineEntry?
        controller.makeSnapshotEntry(
            options: .init(maximumEventsPerEntry: 3, snapshottingAtTime: now),
            completionHandler: { actual = $0 }
        )
        
        let expected = EventTimelineEntry(
            date: now,
            events: [
                EventViewModel(id: "some_event", title: "Some Event", formattedStartTime: string(from: now)),
            ],
            additionalEventsCount: 0
        )
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSnapshot_TwoEvents() {
        let now = Date()
        let inHalfAnHour = now.addingTimeInterval(3600 / 2)
        let earlierEvent = StubEvent(id: "some_event", title: "Some Event", startTime: now)
        let laterEvent = StubEvent(id: "some_other_event", title: "Some Other Event", startTime: inHalfAnHour)
        let repository = StubEventsRepository(events: [earlierEvent, laterEvent])
        setUpController(repository: repository)
        
        var actual: EventTimelineEntry?
        controller.makeSnapshotEntry(
            options: .init(maximumEventsPerEntry: 3, snapshottingAtTime: now),
            completionHandler: { actual = $0 }
        )
        
        let expected = EventTimelineEntry(
            date: now,
            events: [
                EventViewModel(
                    id: "some_event",
                    title: "Some Event",
                    formattedStartTime: string(from: now)
                ),
                
                EventViewModel(
                    id: "some_other_event",
                    title: "Some Other Event",
                    formattedStartTime: string(from: inHalfAnHour)
                )
            ], additionalEventsCount: 0
        )
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSnapshot_TwoEvents_StartingTimelineFromLaterDate() {
        let now = Date()
        let inHalfAnHour = now.addingTimeInterval(3600 / 2)
        let earlierEvent = StubEvent(id: "some_event", title: "Some Event", startTime: now)
        let laterEvent = StubEvent(id: "some_other_event", title: "Some Other Event", startTime: inHalfAnHour)
        let repository = StubEventsRepository(events: [earlierEvent, laterEvent])
        setUpController(repository: repository)
        
        var actual: EventTimelineEntry?
        controller.makeSnapshotEntry(
            options: .init(maximumEventsPerEntry: 3, snapshottingAtTime: inHalfAnHour),
            completionHandler: { actual = $0 }
        )
        
        let expected = EventTimelineEntry(
            date: inHalfAnHour,
            events: [
                EventViewModel(
                    id: "some_other_event",
                    title: "Some Other Event",
                    formattedStartTime: string(from: inHalfAnHour)
                )
            ], additionalEventsCount: 0
        )
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSnapshot_SortsEventsWithinEntryByName() {
        let now = Date()
        let events = [
            StubEvent(id: "2", title: "B Event", startTime: now),
            StubEvent(id: "3", title: "C Event", startTime: now),
            StubEvent(id: "1", title: "A Event", startTime: now)
        ]
        
        let repository = StubEventsRepository(events: events)
        setUpController(repository: repository)
        
        var actual: EventTimelineEntry?
        controller.makeSnapshotEntry(
            options: .init(maximumEventsPerEntry: 3, snapshottingAtTime: now),
            completionHandler: { actual = $0 }
        )
        
        let expected = EventTimelineEntry(
            date: now,
            events: [
                EventViewModel(id: "1", title: "A Event", formattedStartTime: string(from: now)),
                EventViewModel(id: "2", title: "B Event", formattedStartTime: string(from: now)),
                EventViewModel(id: "3", title: "C Event", formattedStartTime: string(from: now))
            ], additionalEventsCount: 0
        )
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSnaphot_ExceedingEventsWithinGroupDropsLastEvents() {
        let now = Date()
        let events = [
            StubEvent(id: "2", title: "B Event", startTime: now),
            StubEvent(id: "3", title: "C Event", startTime: now),
            StubEvent(id: "1", title: "A Event", startTime: now),
            StubEvent(id: "5", title: "E Event", startTime: now),
            StubEvent(id: "4", title: "D Event", startTime: now)
        ]
        
        let repository = StubEventsRepository(events: events)
        setUpController(repository: repository)
        
        var actual: EventTimelineEntry?
        controller.makeSnapshotEntry(
            options: .init(maximumEventsPerEntry: 3, snapshottingAtTime: now),
            completionHandler: { actual = $0 }
        )
        
        let expected = EventTimelineEntry(
            date: now,
            events: [
                EventViewModel(id: "1", title: "A Event", formattedStartTime: string(from: now)),
                EventViewModel(id: "2", title: "B Event", formattedStartTime: string(from: now)),
                EventViewModel(id: "3", title: "C Event", formattedStartTime: string(from: now))
            ], additionalEventsCount: 2
        )
        
        XCTAssertEqual(expected, actual)
    }
    
}
