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
    
    private func emptyEntry(date: Date, category: EventCategory, isFavouritesOnly: Bool) -> EventTimelineEntry {
        EventTimelineEntry(
            date: date,
            content: .empty,
            context: .init(category: category, isFavouritesOnly: isFavouritesOnly)
        )
    }
    
    private func eventsEntry(
        date: Date,
        events: [EventViewModel],
        additionalEventsCount: Int,
        category: EventCategory,
        isFavouritesOnly: Bool
    ) -> EventTimelineEntry {
        EventTimelineEntry(
            date: date,
            content: .events(
                viewModels: events,
                additionalEventsCount: additionalEventsCount
            ),
            context: .init(category: category, isFavouritesOnly: isFavouritesOnly)
        )
    }
    
    private func expectedViewModel(for event: Event) -> EventViewModel {
        EventViewModel(
            id: event.id,
            title: event.title,
            location: event.location,
            formattedStartTime: string(from: event.startTime),
            formattedEndTime: string(from: event.endTime),
            widgetURL: event.deepLinkingContentURL
        )
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
        
        let expectedSnapshotEntry = eventsEntry(
            date: now,
            events: [
                expectedViewModel(for: event)
            ],
            additionalEventsCount: 0,
            category: .upcoming,
            isFavouritesOnly: true
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                emptyEntry(date: inHalfAnHour, category: .upcoming, isFavouritesOnly: true)
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
        
        let expectedSnapshotEntry = eventsEntry(
            date: now,
            events: [
                expectedViewModel(for: earlierEvent),
                expectedViewModel(for: laterEvent)
            ],
            additionalEventsCount: 0,
            category: .upcoming,
            isFavouritesOnly: false
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                
                eventsEntry(
                    date: inHalfAnHour,
                    events: [
                        expectedViewModel(for: laterEvent)
                    ],
                    additionalEventsCount: 0,
                    category: .upcoming,
                    isFavouritesOnly: false
                ),
                
                emptyEntry(date: inOneHour, category: .upcoming, isFavouritesOnly: false)
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
        
        let expectedSnapshotEntry = eventsEntry(
            date: inHalfAnHour,
            events: [
                expectedViewModel(for: laterEvent)
            ],
            additionalEventsCount: 0,
            category: .upcoming,
            isFavouritesOnly: false
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                emptyEntry(date: inOneHour, category: .upcoming, isFavouritesOnly: false)
            ]
        )
        
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(expectedSnapshotEntry, actual?.snapshot)
    }
    
    func testTimeline_SortsEventsWithinEntryByName() {
        let firstEvent = StubEvent(id: "1", title: "A Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        let secondEvent = StubEvent(id: "2", title: "B Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        let thirdEvent = StubEvent(id: "3", title: "C Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        
        let repository = StubEventsRepository(events: [secondEvent, thirdEvent, firstEvent])
        setUpController(repository: repository)
        
        let actual = makeTimeline(timelineStartDate: now)
        
        let expectedSnapshotEntry = eventsEntry(
            date: now,
            events: [
                expectedViewModel(for: firstEvent),
                expectedViewModel(for: secondEvent),
                expectedViewModel(for: thirdEvent)
            ],
            additionalEventsCount: 0,
            category: .upcoming,
            isFavouritesOnly: false
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                emptyEntry(date: inHalfAnHour, category: .upcoming, isFavouritesOnly: false)
            ]
        )
        
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(expectedSnapshotEntry, actual?.snapshot)
    }
    
    func testTimeline_ExceedingEventsWithinGroupDropsLastEvents() {
        let firstEvent = StubEvent(id: "1", title: "A Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        let secondEvent = StubEvent(id: "2", title: "B Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        let thirdEvent = StubEvent(id: "3", title: "C Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        let fourthEvent = StubEvent(id: "4", title: "D Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        let fifthEvent = StubEvent(id: "5", title: "E Event", location: "Location", startTime: now, endTime: inHalfAnHour)

        let repository = StubEventsRepository(events: [
            secondEvent,
            thirdEvent,
            firstEvent,
            fifthEvent,
            fourthEvent
        ])
        
        setUpController(repository: repository)
        
        let actual = makeTimeline(timelineStartDate: now)
        
        let expectedSnapshotEntry = eventsEntry(
            date: now,
            events: [
                expectedViewModel(for: firstEvent),
                expectedViewModel(for: secondEvent),
                expectedViewModel(for: thirdEvent)
            ],
            additionalEventsCount: 2,
            category: .upcoming,
            isFavouritesOnly: false
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                emptyEntry(date: inHalfAnHour, category: .upcoming, isFavouritesOnly: false)
            ]
        )
        
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(expectedSnapshotEntry, actual?.snapshot)
    }
    
    func testYieldsEmptyEntryWhenNoEventsAvailable() {
        let repository = StubEventsRepository(events: [])
        setUpController(repository: repository)
        
        let actual = makeTimeline(timelineStartDate: now)
        
        let expectedSnapshotEntry = emptyEntry(date: now, category: .upcoming, isFavouritesOnly: false)
        
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
        
        func proposedEntryStartTime(forEventsClustereredAt clusterTime: Date) -> Date {
            clusterTime
        }
        
    }
    
    func testDoesNotIncludeEventsThatAreRejectedByFilteringPolicy() {
        let firstEvent = StubEvent(id: "1", title: "A Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        let secondEvent = StubEvent(id: "2", title: "B Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        let thirdEvent = StubEvent(id: "3", title: "C Event", location: "Location", startTime: now, endTime: inOneHour)
        let fourthEvent = StubEvent(id: "4", title: "D Event", location: "Location", startTime: inHalfAnHour, endTime: inOneHour)
        let fifthEvent = StubEvent(id: "5", title: "E Event", location: "Location", startTime: inHalfAnHour, endTime: inOneHour)

        let filteringPolicy = FilterByEventIdentifierPolicy(removeEventsWithIdentifiers: ["3", "5"])
        
        let repository = StubEventsRepository(events: [
            firstEvent,
            secondEvent,
            thirdEvent,
            fourthEvent,
            fifthEvent
        ])
        
        setUpController(repository: repository, filteringPolicy: filteringPolicy)
        
        let actual = makeTimeline(timelineStartDate: now)
        
        let firstExpectedSnapshotEntry = eventsEntry(
            date: now,
            events: [
                expectedViewModel(for: firstEvent),
                expectedViewModel(for: secondEvent),
                expectedViewModel(for: fourthEvent)
            ],
            additionalEventsCount: 0,
            category: .upcoming,
            isFavouritesOnly: false
        )
        
        let secondExpectedSnapshotEntry = eventsEntry(
            date: inHalfAnHour,
            events: [
                expectedViewModel(for: fourthEvent)
            ],
            additionalEventsCount: 0,
            category: .upcoming,
            isFavouritesOnly: false
        )
        
        let expected = EventsTimeline(
            snapshot: firstExpectedSnapshotEntry,
            entries: [
                firstExpectedSnapshotEntry,
                secondExpectedSnapshotEntry,
                emptyEntry(date: inOneHour, category: .upcoming, isFavouritesOnly: false)
            ]
        )
        
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(firstExpectedSnapshotEntry, actual?.snapshot)
    }
    
    func testStartingTimelineBeforeFirstEvent() {
        let (inTheFuture, inTheFuturePlusHalfAnHour) = (now!, now.addingTimeInterval(3600 / 2))
        now = now.addingTimeInterval(3600 * 24 * 3 * -1)
        
        let event = StubEvent(
            id: "some_event",
            title: "Some Event",
            location: "Location",
            startTime: inTheFuture,
            endTime: inTheFuturePlusHalfAnHour
        )
        
        let repository = StubEventsRepository(events: [event])
        setUpController(repository: repository)
        
        let actual = makeTimeline(timelineStartDate: now, isFavouritesOnly: true)

        let expectedSnapshotEntry = emptyEntry(date: now, category: .upcoming, isFavouritesOnly: true)
        
        let expectedEventEntry = eventsEntry(
            date: inTheFuture,
            events: [
                expectedViewModel(for: event)
            ],
            additionalEventsCount: 0,
            category: .upcoming,
            isFavouritesOnly: true
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                expectedEventEntry,
                emptyEntry(date: inTheFuturePlusHalfAnHour, category: .upcoming, isFavouritesOnly: true)
            ]
        )
        
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(expectedSnapshotEntry, actual?.snapshot)
    }
    
    struct RemoveAllEventsFilteringPolicy: TimelineEntryFilteringPolicy {
        
        func filterEvents(_ events: [Event], inGroupStartingAt startTime: Date) -> [Event] {
            []
        }
        
        func proposedEntryStartTime(forEventsClustereredAt clusterTime: Date) -> Date {
            clusterTime
        }
        
    }
    
    func testEntriesWithNoEligibleEventsAreIncluded() {
        let event = StubEvent(
            id: "some_event",
            title: "Some Event",
            location: "Location",
            startTime: now,
            endTime: inHalfAnHour
        )
        
        let repository = StubEventsRepository(events: [event])
        setUpController(repository: repository, filteringPolicy: RemoveAllEventsFilteringPolicy())
        
        let actual = makeTimeline(timelineStartDate: now, isFavouritesOnly: true)
        
        let expectedSnapshotEntry = emptyEntry(date: now, category: .upcoming, isFavouritesOnly: true)
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry
            ]
        )
        
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(expectedSnapshotEntry, actual?.snapshot)
    }
    
    struct ShiftEntriesBackTimelineFilteringPolicy: TimelineEntryFilteringPolicy {
        
        var expectedFilteringTime: Date
        var shiftEntriesBackBy: TimeInterval
        
        func filterEvents(_ events: [Event], inGroupStartingAt startTime: Date) -> [Event] {
            startTime == expectedFilteringTime ? events : []
        }
        
        func proposedEntryStartTime(forEventsClustereredAt clusterTime: Date) -> Date {
            clusterTime.addingTimeInterval(-shiftEntriesBackBy)
        }
        
    }
    
    func testEntriesUseProposedTimeFromPolicyDuringClustering() {
        let event = StubEvent(
            id: "some_event",
            title: "Some Event",
            location: "Location",
            startTime: now,
            endTime: inHalfAnHour
        )
        
        let oneHour: TimeInterval = 3600
        let expectedFilteringTime = now.addingTimeInterval(-oneHour)
        let shiftEntriesBackPolicy = ShiftEntriesBackTimelineFilteringPolicy(expectedFilteringTime: expectedFilteringTime, shiftEntriesBackBy: oneHour)
        
        let repository = StubEventsRepository(events: [event])
        setUpController(repository: repository, filteringPolicy: shiftEntriesBackPolicy)
        
        let actual = makeTimeline(timelineStartDate: now, isFavouritesOnly: true)
        
        let expectedSnapshotEntry = eventsEntry(
            date: now.addingTimeInterval(-oneHour),
            events: [
                expectedViewModel(for: event)
            ],
            additionalEventsCount: 0,
            category: .upcoming,
            isFavouritesOnly: true
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                emptyEntry(date: inHalfAnHour, category: .upcoming, isFavouritesOnly: true)
            ]
        )
        
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(expectedSnapshotEntry, actual?.snapshot)
    }
    
}
