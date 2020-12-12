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
    
    private func setUpController(
        repository: EventRepository,
        filteringPolicy: TimelineEntryFilteringPolicy = DoNotFilterAnyEventsPolicy()
    ) {
        controller = EventsTimelineController(
            repository: repository,
            filteringPolicy: filteringPolicy,
            eventTimeFormatter: formatter
        )
    }
    
    private func makeTimeline(
        timelineStartDate: Date,
        maximumEventsPerEntry: Int = 3,
        eventCategory: EventCategory = .upcoming,
        isFavouritesOnly: Bool = false
    ) -> EventsTimeline? {
        var actual: EventsTimeline?
        controller.makeTimeline(
            options: .init(
                maximumEventsPerEntry: maximumEventsPerEntry,
                timelineStartDate: timelineStartDate,
                eventCategory: eventCategory,
                isFavouritesOnly: isFavouritesOnly
            ),
            completionHandler: { actual = $0 }
        )
        
        return actual
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
        
        let actual = makeTimeline(timelineStartDate: now, isFavouritesOnly: true)
        
        let expectedSnapshotEntry = EventTimelineEntry(
            date: now,
            content: .events(
                viewModels: [
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
            ),
            context: EventTimelineEntry.Context(category: .upcoming, isFavouritesOnly: true)
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                
                EventTimelineEntry(
                    date: inHalfAnHour,
                    content: .endOfSchedule,
                    context: .init(category: .upcoming, isFavouritesOnly: true)
                )
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
        
        let actual = makeTimeline(timelineStartDate: now)
        
        let expectedSnapshotEntry = EventTimelineEntry(
            date: now,
            content: .events(
                viewModels: [
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
                ],
                additionalEventsCount: 0
            ),
            context: EventTimelineEntry.Context(category: .upcoming, isFavouritesOnly: false)
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                
                EventTimelineEntry(
                    date: inHalfAnHour,
                    content: .events(
                        viewModels: [
                            EventViewModel(
                                id: "some_other_event",
                                title: "Some Other Event",
                                location: "Other Location",
                                formattedStartTime: string(from: inHalfAnHour),
                                formattedEndTime: string(from: inOneHour),
                                widgetURL: laterEvent.deepLinkingContentURL
                            )
                        ],
                        additionalEventsCount: 0
                    ),
                    context: EventTimelineEntry.Context(category: .upcoming, isFavouritesOnly: false)
                ),
                
                EventTimelineEntry(
                    date: inOneHour,
                    content: .endOfSchedule,
                    context: .init(category: .upcoming, isFavouritesOnly: false)
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
        
        let actual = makeTimeline(timelineStartDate: inHalfAnHour)
        
        let expectedSnapshotEntry = EventTimelineEntry(
            date: inHalfAnHour,
            content: .events(
                viewModels: [
                    EventViewModel(
                        id: "some_other_event",
                        title: "Some Other Event",
                        location: "Other Location",
                        formattedStartTime: string(from: inHalfAnHour),
                        formattedEndTime: string(from: inOneHour),
                        widgetURL: laterEvent.deepLinkingContentURL
                    )
                ],
                additionalEventsCount: 0
            ),
            context: EventTimelineEntry.Context(category: .upcoming, isFavouritesOnly: false)
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                
                EventTimelineEntry(
                    date: inOneHour,
                    content: .endOfSchedule,
                    context: .init(category: .upcoming, isFavouritesOnly: false)
                )
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
        
        let actual = makeTimeline(timelineStartDate: now)
        
        let expectedSnapshotEntry = EventTimelineEntry(
            date: now,
            content: .events(
                viewModels: [
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
                ],
                additionalEventsCount: 0
            ),
            context: EventTimelineEntry.Context(category: .upcoming, isFavouritesOnly: false)
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                
                EventTimelineEntry(
                    date: inHalfAnHour,
                    content: .endOfSchedule,
                    context: .init(category: .upcoming, isFavouritesOnly: false)
                )
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
        
        let actual = makeTimeline(timelineStartDate: now)
        
        let expectedSnapshotEntry = EventTimelineEntry(
            date: now,
            content: .events(
                viewModels: [
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
                ],
                additionalEventsCount: 2
            ),
            context: EventTimelineEntry.Context(category: .upcoming, isFavouritesOnly: false)
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                
                EventTimelineEntry(
                    date: inHalfAnHour,
                    content: .endOfSchedule,
                    context: .init(category: .upcoming, isFavouritesOnly: false)
                )
            ]
        )
        
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(expectedSnapshotEntry, actual?.snapshot)
    }
    
    func testYieldsEmptyEntryWhenNoEventsAvailable() {
        let repository = StubEventsRepository(events: [])
        setUpController(repository: repository)
        
        let actual = makeTimeline(timelineStartDate: now)
        
        let expectedSnapshotEntry = EventTimelineEntry(
            date: now,
            content: .endOfSchedule,
            context: .init(category: .upcoming, isFavouritesOnly: false)
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
    
    struct FilterByEventIdentifierPolicy: TimelineEntryFilteringPolicy {
        
        var removeEventsWithIdentifiers: [String]
        
        func filterEvents(_ events: [Event], inGroupStartingAt startTime: Date) -> [Event] {
            events.filter({ removeEventsWithIdentifiers.contains($0.id) == false })
        }
        
    }
    
    func testDoesNotIncludeEventsThatAreRejectedByFilteringPolicy() {
        let events = [
            StubEvent(id: "1", title: "A Event", location: "Location", startTime: now, endTime: inHalfAnHour),
            StubEvent(id: "2", title: "B Event", location: "Location", startTime: now, endTime: inHalfAnHour),
            StubEvent(id: "3", title: "C Event", location: "Location", startTime: now, endTime: inOneHour),
            StubEvent(id: "4", title: "D Event", location: "Location", startTime: inHalfAnHour, endTime: inOneHour),
            StubEvent(id: "5", title: "E Event", location: "Location", startTime: inHalfAnHour, endTime: inOneHour)
        ]
        
        let filteringPolicy = FilterByEventIdentifierPolicy(removeEventsWithIdentifiers: ["3", "5"])
        
        let repository = StubEventsRepository(events: events)
        setUpController(repository: repository, filteringPolicy: filteringPolicy)
        
        let actual = makeTimeline(timelineStartDate: now)
        
        let firstExpectedSnapshotEntry = EventTimelineEntry(
            date: now,
            content: .events(
                viewModels: [
                    EventViewModel(
                        id: "1",
                        title: "A Event",
                        location: "Location",
                        formattedStartTime: string(from: now),
                        formattedEndTime: string(from: inHalfAnHour),
                        widgetURL: events[0].deepLinkingContentURL
                    ),
                    EventViewModel(
                        id: "2",
                        title: "B Event",
                        location: "Location",
                        formattedStartTime: string(from: now),
                        formattedEndTime: string(from: inHalfAnHour),
                        widgetURL: events[1].deepLinkingContentURL
                    ),
                    EventViewModel(
                        id: "4",
                        title: "D Event",
                        location: "Location",
                        formattedStartTime: string(from: inHalfAnHour),
                        formattedEndTime: string(from: inOneHour),
                        widgetURL: events[3].deepLinkingContentURL
                    )
                ],
                additionalEventsCount: 0
            ),
            context: EventTimelineEntry.Context(category: .upcoming, isFavouritesOnly: false)
        )
        
        let secondExpectedSnapshotEntry = EventTimelineEntry(
            date: inHalfAnHour,
            content: .events(
                viewModels: [
                    EventViewModel(
                        id: "4",
                        title: "D Event",
                        location: "Location",
                        formattedStartTime: string(from: inHalfAnHour),
                        formattedEndTime: string(from: inOneHour),
                        widgetURL: events[3].deepLinkingContentURL
                    )
                ],
                additionalEventsCount: 0
            ),
            context: EventTimelineEntry.Context(category: .upcoming, isFavouritesOnly: false)
        )
        
        let expected = EventsTimeline(
            snapshot: firstExpectedSnapshotEntry,
            entries: [
                firstExpectedSnapshotEntry,
                secondExpectedSnapshotEntry,
                
                EventTimelineEntry(
                    date: inOneHour,
                    content: .endOfSchedule,
                    context: .init(category: .upcoming, isFavouritesOnly: false)
                )
            ]
        )
        
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(firstExpectedSnapshotEntry, actual?.snapshot)
    }
    
}
