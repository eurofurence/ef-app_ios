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
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: now, eventCategory: .upcoming),
            completionHandler: { actual = $0 }
        )
        
        let expectedSnapshotEntry = EventTimelineEntry(
            date: now,
            eventCategory: .upcoming,
            events: [
                EventViewModel(
                    id: "some_event",
                    title: "Some Event",
                    location: "Location",
                    formattedStartTime: string(from: now),
                    formattedEndTime: string(from: inHalfAnHour),
                    widgetURL: event.deepLinkingContentURL
                )
            ],
            additionalEventsCount: 0
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry
            ]
        )
        
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(expectedSnapshotEntry, actual?.snapshot)
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
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: now, eventCategory: .upcoming),
            completionHandler: { actual = $0 }
        )
        
        let expectedSnapshotEntry = EventTimelineEntry(
            date: now,
            eventCategory: .upcoming,
            events: [
                EventViewModel(
                    id: "some_event",
                    title: "Some Event",
                    location: "Location",
                    formattedStartTime: string(from: now),
                    formattedEndTime: string(from: inHalfAnHour),
                    widgetURL: earlierEvent.deepLinkingContentURL
                ),
                
                EventViewModel(
                    id: "some_other_event",
                    title: "Some Other Event",
                    location: "Other Location",
                    formattedStartTime: string(from: inHalfAnHour),
                    formattedEndTime: string(from: inOneHour),
                    widgetURL: laterEvent.deepLinkingContentURL
                )
            ], additionalEventsCount: 0
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                
                EventTimelineEntry(
                    date: inHalfAnHour,
                    eventCategory: .upcoming,
                    events: [
                        EventViewModel(
                            id: "some_other_event",
                            title: "Some Other Event",
                            location: "Other Location",
                            formattedStartTime: string(from: inHalfAnHour),
                            formattedEndTime: string(from: inOneHour),
                            widgetURL: laterEvent.deepLinkingContentURL
                        )
                    ], additionalEventsCount: 0
                )
            ]
        )
        
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(expectedSnapshotEntry, actual?.snapshot)
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
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: inHalfAnHour, eventCategory: .upcoming),
            completionHandler: { actual = $0 }
        )
        
        let expectedSnapshotEntry = EventTimelineEntry(
            date: inHalfAnHour,
            eventCategory: .upcoming,
            events: [
                EventViewModel(
                    id: "some_other_event",
                    title: "Some Other Event",
                    location: "Other Location",
                    formattedStartTime: string(from: inHalfAnHour),
                    formattedEndTime: string(from: inOneHour),
                    widgetURL: laterEvent.deepLinkingContentURL
                )
            ], additionalEventsCount: 0
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry
            ]
        )
        
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(expectedSnapshotEntry, actual?.snapshot)
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
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: now, eventCategory: .upcoming),
            completionHandler: { actual = $0 }
        )
        
        let expectedSnapshotEntry = EventTimelineEntry(
            date: now,
            eventCategory: .upcoming,
            events: [
                EventViewModel(
                    id: "1",
                    title: "A Event",
                    location: "Location",
                    formattedStartTime: string(from: now),
                    formattedEndTime: string(from: inHalfAnHour),
                    widgetURL: events[2].deepLinkingContentURL
                ),
                EventViewModel(
                    id: "2",
                    title: "B Event",
                    location: "Location",
                    formattedStartTime: string(from: now),
                    formattedEndTime: string(from: inHalfAnHour),
                    widgetURL: events[0].deepLinkingContentURL
                ),
                EventViewModel(
                    id: "3",
                    title: "C Event",
                    location: "Location",
                    formattedStartTime: string(from: now),
                    formattedEndTime: string(from: inHalfAnHour),
                    widgetURL: events[1].deepLinkingContentURL
                )
            ], additionalEventsCount: 0
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry
            ]
        )
        
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(expectedSnapshotEntry, actual?.snapshot)
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
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: now, eventCategory: .upcoming),
            completionHandler: { actual = $0 }
        )
        
        let expectedSnapshotEntry = EventTimelineEntry(
            date: now,
            eventCategory: .upcoming,
            events: [
                EventViewModel(
                    id: "1",
                    title: "A Event",
                    location: "Location",
                    formattedStartTime: string(from: now),
                    formattedEndTime: string(from: inHalfAnHour),
                    widgetURL: events[2].deepLinkingContentURL
                ),
                EventViewModel(
                    id: "2",
                    title: "B Event",
                    location: "Location",
                    formattedStartTime: string(from: now),
                    formattedEndTime: string(from: inHalfAnHour),
                    widgetURL: events[0].deepLinkingContentURL
                ),
                EventViewModel(
                    id: "3",
                    title: "C Event",
                    location: "Location",
                    formattedStartTime: string(from: now),
                    formattedEndTime: string(from: inHalfAnHour),
                    widgetURL: events[1].deepLinkingContentURL
                )
            ], additionalEventsCount: 2
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry
            ]
        )
        
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(expectedSnapshotEntry, actual?.snapshot)
    }
    
    func testYieldsEmptyEntryWhenNoEventsAvailable() {
        let repository = StubEventsRepository(events: [])
        setUpController(repository: repository)
        
        var actual: EventsTimeline?
        controller.makeTimeline(
            options: .init(maximumEventsPerEntry: 3, timelineStartDate: now, eventCategory: .upcoming),
            completionHandler: { actual = $0 }
        )
        
        let expectedSnapshotEntry = EventTimelineEntry(
            date: now,
            eventCategory: .upcoming,
            events: [],
            additionalEventsCount: 0
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry
            ]
        )
        
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(expectedSnapshotEntry, actual?.snapshot)
    }
    
}
