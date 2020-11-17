import EventsWidgetLogic
import XCTest

class EventsTimelineControllerTests: XCTestCase {
    
    private var formatter: FakeEventTimeFormatter!
    private var controller: EventsTimelineController!
    private var now: Date!
    private var inHalfAnHour: Date!
    private var inOneHour: Date!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        formatter = FakeEventTimeFormatter()
        now = Date()
        inHalfAnHour = now.addingTimeInterval(3600 / 2)
        inOneHour = now.addingTimeInterval(3600)
    }
    
    private func setUpController(repository: EventRepository) {
        controller = EventsTimelineController(repository: repository, eventTimeFormatter: formatter)
    }
    
    private func string(from date: Date) -> String {
        formatter.string(from: date)
    }
    
    // MARK: - Timeline Tests
    
    func testTimeline_OneEvent() throws {
        let event = StubEvent(
            id: "some_event",
            title: "Some Event",
            location: "Location",
            startTime: now,
            endTime: inHalfAnHour
        )
        
        let repository = StubEventsRepository(events: [event])
        setUpController(repository: repository)
        
        var actual: EventsTimeline?
        controller.makeTimeline(
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: now),
            completionHandler: { actual = $0 }
        )
        
        let expected = EventsTimeline(
            entries: [
                EventTimelineEntry(
                    date: now,
                    events: [
                        EventViewModel(
                            id: "some_event",
                            title: "Some Event",
                            location: "Location",
                            formattedStartTime: string(from: now),
                            formattedEndTime: string(from: inHalfAnHour)
                        )
                    ],
                    additionalEventsCount: 0
                )
            ]
        )
        
        XCTAssertEqual(expected, actual)
    }
    
    func testTimeline_TwoEvents_StaggeredStartTimesYieldsTwoEntries() {
        let earlierEvent = StubEvent(
            id: "some_event",
            title: "Some Event",
            location: "Location",
            startTime: now,
            endTime: inHalfAnHour
        )
        
        let laterEvent = StubEvent(
            id: "some_other_event",
            title: "Some Other Event",
            location: "Other Location",
            startTime: inHalfAnHour,
            endTime: inOneHour
        )
        
        let repository = StubEventsRepository(events: [earlierEvent, laterEvent])
        setUpController(repository: repository)
        
        var actual: EventsTimeline?
        controller.makeTimeline(
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: now),
            completionHandler: { actual = $0 }
        )
        
        let expected = EventsTimeline(
            entries: [
                EventTimelineEntry(
                    date: now,
                    events: [
                        EventViewModel(
                            id: "some_event",
                            title: "Some Event",
                            location: "Location",
                            formattedStartTime: string(from: now),
                            formattedEndTime: string(from: inHalfAnHour)
                        ),
                        
                        EventViewModel(
                            id: "some_other_event",
                            title: "Some Other Event",
                            location: "Other Location",
                            formattedStartTime: string(from: inHalfAnHour),
                            formattedEndTime: string(from: inOneHour)
                        )
                    ], additionalEventsCount: 0
                ),
                
                EventTimelineEntry(
                    date: inHalfAnHour,
                    events: [
                        EventViewModel(
                            id: "some_other_event",
                            title: "Some Other Event",
                            location: "Other Location",
                            formattedStartTime: string(from: inHalfAnHour),
                            formattedEndTime: string(from: inOneHour)
                        )
                    ], additionalEventsCount: 0
                )
            ]
        )
        
        XCTAssertEqual(expected, actual)
    }
    
    func testTimeline_TwoEvents_StartingTimelineFromLaterDate() {
        let earlierEvent = StubEvent(
            id: "some_event",
            title: "Some Event",
            location: "Location",
            startTime: now,
            endTime: inHalfAnHour
        )
        
        let laterEvent = StubEvent(
            id: "some_other_event",
            title: "Some Other Event",
            location: "Other Location",
            startTime: inHalfAnHour,
            endTime: inOneHour
        )
        
        let repository = StubEventsRepository(events: [earlierEvent, laterEvent])
        setUpController(repository: repository)
        
        var actual: EventsTimeline?
        controller.makeTimeline(
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: inHalfAnHour),
            completionHandler: { actual = $0 }
        )
        
        let expected = EventsTimeline(
            entries: [
                EventTimelineEntry(
                    date: inHalfAnHour,
                    events: [
                        EventViewModel(
                            id: "some_other_event",
                            title: "Some Other Event",
                            location: "Other Location",
                            formattedStartTime: string(from: inHalfAnHour),
                            formattedEndTime: string(from: inOneHour)
                        )
                    ], additionalEventsCount: 0
                )
            ]
        )
        
        XCTAssertEqual(expected, actual)
    }
    
    func testTimeline_SortsEventsWithinEntryByName() {
        let events = [
            StubEvent(id: "2", title: "B Event", location: "Location", startTime: now, endTime: inHalfAnHour),
            StubEvent(id: "3", title: "C Event", location: "Location", startTime: now, endTime: inHalfAnHour),
            StubEvent(id: "1", title: "A Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        ]
        
        let repository = StubEventsRepository(events: events)
        setUpController(repository: repository)
        
        var actual: EventsTimeline?
        controller.makeTimeline(
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: now),
            completionHandler: { actual = $0 }
        )
        
        let expected = EventsTimeline(
            entries: [
                EventTimelineEntry(
                    date: now,
                    events: [
                        EventViewModel(
                            id: "1",
                            title: "A Event",
                            location: "Location",
                            formattedStartTime: string(from: now),
                            formattedEndTime: string(from: inHalfAnHour)
                        ),
                        EventViewModel(
                            id: "2",
                            title: "B Event",
                            location: "Location",
                            formattedStartTime: string(from: now),
                            formattedEndTime: string(from: inHalfAnHour)
                        ),
                        EventViewModel(
                            id: "3",
                            title: "C Event",
                            location: "Location",
                            formattedStartTime: string(from: now),
                            formattedEndTime: string(from: inHalfAnHour)
                        )
                    ], additionalEventsCount: 0
                )
            ]
        )
        
        XCTAssertEqual(expected, actual)
    }
    
    func testTimeline_ExceedingEventsWithinGroupDropsLastEvents() {
        let events = [
            StubEvent(id: "2", title: "B Event", location: "Location", startTime: now, endTime: inHalfAnHour),
            StubEvent(id: "3", title: "C Event", location: "Location", startTime: now, endTime: inHalfAnHour),
            StubEvent(id: "1", title: "A Event", location: "Location", startTime: now, endTime: inHalfAnHour),
            StubEvent(id: "5", title: "E Event", location: "Location", startTime: now, endTime: inHalfAnHour),
            StubEvent(id: "4", title: "D Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        ]
        
        let repository = StubEventsRepository(events: events)
        setUpController(repository: repository)
        
        var actual: EventsTimeline?
        controller.makeTimeline(
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: now),
            completionHandler: { actual = $0 }
        )
        
        let expected = EventsTimeline(
            entries: [
                EventTimelineEntry(
                    date: now,
                    events: [
                        EventViewModel(
                            id: "1",
                            title: "A Event",
                            location: "Location",
                            formattedStartTime: string(from: now),
                            formattedEndTime: string(from: inHalfAnHour)
                        ),
                        EventViewModel(
                            id: "2",
                            title: "B Event",
                            location: "Location",
                            formattedStartTime: string(from: now),
                            formattedEndTime: string(from: inHalfAnHour)
                        ),
                        EventViewModel(
                            id: "3",
                            title: "C Event",
                            location: "Location",
                            formattedStartTime: string(from: now),
                            formattedEndTime: string(from: inHalfAnHour)
                        )
                    ], additionalEventsCount: 2
                )
            ]
        )
        
        XCTAssertEqual(expected, actual)
    }
    
    // MARK: - Snapshot Tests
    
    func testSnapshot_OneEvent() {
        let event = StubEvent(
            id: "some_event",
            title: "Some Event",
            location: "Location",
            startTime: now,
            endTime: inHalfAnHour
        )
        
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
                EventViewModel(
                    id: "some_event",
                    title: "Some Event",
                    location: "Location",
                    formattedStartTime: string(from: now),
                    formattedEndTime: string(from: inHalfAnHour)
                ),
            ],
            additionalEventsCount: 0
        )
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSnapshot_TwoEvents() {
        let earlierEvent = StubEvent(
            id: "some_event",
            title: "Some Event",
            location: "Location",
            startTime: now,
            endTime: inHalfAnHour
        )
        
        let laterEvent = StubEvent(
            id: "some_other_event",
            title: "Some Other Event",
            location: "Other Location",
            startTime: inHalfAnHour,
            endTime: inOneHour
        )
        
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
                    location: "Location",
                    formattedStartTime: string(from: now),
                    formattedEndTime: string(from: inHalfAnHour)
                ),
                
                EventViewModel(
                    id: "some_other_event",
                    title: "Some Other Event",
                    location: "Other Location",
                    formattedStartTime: string(from: inHalfAnHour),
                    formattedEndTime: string(from: inOneHour)
                )
            ], additionalEventsCount: 0
        )
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSnapshot_TwoEvents_StartingTimelineFromLaterDate() {
        let earlierEvent = StubEvent(
            id: "some_event",
            title: "Some Event",
            location: "Location",
            startTime: now,
            endTime: inHalfAnHour
        )
        
        let laterEvent = StubEvent(
            id: "some_other_event",
            title: "Some Other Event",
            location: "Other Location",
            startTime: inHalfAnHour,
            endTime: inOneHour
        )
        
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
                    location: "Other Location",
                    formattedStartTime: string(from: inHalfAnHour),
                    formattedEndTime: string(from: inOneHour)
                )
            ], additionalEventsCount: 0
        )
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSnapshot_SortsEventsWithinEntryByName() {
        let events = [
            StubEvent(id: "2", title: "B Event", location: "Location", startTime: now, endTime: inHalfAnHour),
            StubEvent(id: "3", title: "C Event", location: "Location", startTime: now, endTime: inHalfAnHour),
            StubEvent(id: "1", title: "A Event", location: "Location", startTime: now, endTime: inHalfAnHour)
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
                EventViewModel(
                    id: "1",
                    title: "A Event",
                    location: "Location",
                    formattedStartTime: string(from: now),
                    formattedEndTime: string(from: inHalfAnHour)
                ),
                EventViewModel(
                    id: "2",
                    title: "B Event",
                    location: "Location",
                    formattedStartTime: string(from: now),
                    formattedEndTime: string(from: inHalfAnHour)
                ),
                EventViewModel(
                    id: "3",
                    title: "C Event",
                    location: "Location",
                    formattedStartTime: string(from: now),
                    formattedEndTime: string(from: inHalfAnHour)
                )
            ], additionalEventsCount: 0
        )
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSnaphot_ExceedingEventsWithinGroupDropsLastEvents() {
        let events = [
            StubEvent(id: "2", title: "B Event", location: "Location", startTime: now, endTime: inHalfAnHour),
            StubEvent(id: "3", title: "C Event", location: "Location", startTime: now, endTime: inHalfAnHour),
            StubEvent(id: "1", title: "A Event", location: "Location", startTime: now, endTime: inHalfAnHour),
            StubEvent(id: "5", title: "E Event", location: "Location", startTime: now, endTime: inHalfAnHour),
            StubEvent(id: "4", title: "D Event", location: "Location", startTime: now, endTime: inHalfAnHour)
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
                EventViewModel(
                    id: "1",
                    title: "A Event",
                    location: "Location",
                    formattedStartTime: string(from: now),
                    formattedEndTime: string(from: inHalfAnHour)
                ),
                EventViewModel(
                    id: "2",
                    title: "B Event",
                    location: "Location",
                    formattedStartTime: string(from: now),
                    formattedEndTime: string(from: inHalfAnHour)
                ),
                EventViewModel(
                    id: "3",
                    title: "C Event",
                    location: "Location",
                    formattedStartTime: string(from: now),
                    formattedEndTime: string(from: inHalfAnHour)
                )
            ], additionalEventsCount: 2
        )
        
        XCTAssertEqual(expected, actual)
    }
    
}
