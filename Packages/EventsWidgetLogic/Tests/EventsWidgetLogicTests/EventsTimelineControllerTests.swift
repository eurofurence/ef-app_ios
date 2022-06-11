import EventsWidgetLogic
import XCTest

// swiftlint:disable file_length
// swiftlint:disable type_body_length
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
    
    private func event(id: String, title: String, location: String, startTime: Date, endTime: Date) -> Event {
        StubEvent(id: id, title: title, location: location, startTime: startTime, endTime: endTime)
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
    
    private func emptyEntry(
        date: Date,
        accessibleSummary: String,
        category: EventCategory,
        isFavouritesOnly: Bool
    ) -> EventTimelineEntry {
        EventTimelineEntry(
            date: date,
            accessibleSummary: accessibleSummary,
            content: .empty,
            context: .init(category: category, isFavouritesOnly: isFavouritesOnly)
        )
    }
    
    private func eventsEntry(
        date: Date,
        accessibleSummary: String,
        events: [EventViewModel],
        category: EventCategory,
        isFavouritesOnly: Bool
    ) -> EventTimelineEntry {
        EventTimelineEntry(
            date: date,
            accessibleSummary: accessibleSummary,
            content: .events(viewModels: events),
            context: .init(category: category, isFavouritesOnly: isFavouritesOnly)
        )
    }
    
    private func expectedViewModel(for event: Event) -> EventViewModel {
        let startTime: String = string(from: event.startTime)
        let englishAccessibilityDescription = "\(event.title), starting at \(startTime) in \(event.location)"
        
        return EventViewModel(
            id: event.id,
            title: event.title,
            location: event.location,
            formattedStartTime: startTime,
            widgetURL: event.deepLinkingContentURL,
            accessibilitySummary: englishAccessibilityDescription
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
            accessibleSummary: "1 upcoming favourite event",
            events: [
                expectedViewModel(for: event)
            ],
            category: .upcoming,
            isFavouritesOnly: true
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                emptyEntry(
                    date: inHalfAnHour,
                    accessibleSummary: "no upcoming favourite events",
                    category: .upcoming,
                    isFavouritesOnly: true
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
        
        let expectedSnapshotEntry = eventsEntry(
            date: now,
            accessibleSummary: "2 upcoming events",
            events: [expectedViewModel(for: earlierEvent), expectedViewModel(for: laterEvent)],
            category: .upcoming,
            isFavouritesOnly: false
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                
                eventsEntry(
                    date: inHalfAnHour,
                    accessibleSummary: "1 upcoming event",
                    events: [expectedViewModel(for: laterEvent)],
                    category: .upcoming,
                    isFavouritesOnly: false
                ),
                
                emptyEntry(
                    date: inOneHour,
                    accessibleSummary: "no upcoming events",
                    category: .upcoming,
                    isFavouritesOnly: false
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
        
        let expectedSnapshotEntry = eventsEntry(
            date: inHalfAnHour,
            accessibleSummary: "1 upcoming event",
            events: [
                expectedViewModel(for: laterEvent)
            ],
            category: .upcoming,
            isFavouritesOnly: false
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                emptyEntry(
                    date: inOneHour,
                    accessibleSummary: "no upcoming events",
                    category: .upcoming,
                    isFavouritesOnly: false
                )
            ]
        )
        
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(expectedSnapshotEntry, actual?.snapshot)
    }
    
    func testTimeline_SortsEventsWithinEntryByName() {
        let firstEvent = event(id: "1", title: "A Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        let secondEvent = event(id: "2", title: "B Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        let thirdEvent = event(id: "3", title: "C Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        
        let repository = StubEventsRepository(events: [secondEvent, thirdEvent, firstEvent])
        setUpController(repository: repository)
        
        let actual = makeTimeline(timelineStartDate: now)
        
        let expectedSnapshotEntry = eventsEntry(
            date: now,
            accessibleSummary: "3 upcoming events",
            events: [
                expectedViewModel(for: firstEvent),
                expectedViewModel(for: secondEvent),
                expectedViewModel(for: thirdEvent)
            ],
            category: .upcoming,
            isFavouritesOnly: false
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                emptyEntry(
                    date: inHalfAnHour,
                    accessibleSummary: "no upcoming events",
                    category: .upcoming,
                    isFavouritesOnly: false
                )
            ]
        )
        
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(expectedSnapshotEntry, actual?.snapshot)
    }
    
    func testTimeline_ExceedingEventsWithinGroupDropsLastEvents() {
        let firstEvent = event(id: "1", title: "A Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        let secondEvent = event(id: "2", title: "B Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        let thirdEvent = event(id: "3", title: "C Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        let fourthEvent = event(id: "4", title: "D Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        let fifthEvent = event(id: "5", title: "E Event", location: "Location", startTime: now, endTime: inHalfAnHour)

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
            accessibleSummary: "3 upcoming events",
            events: [
                expectedViewModel(for: firstEvent),
                expectedViewModel(for: secondEvent),
                expectedViewModel(for: thirdEvent)
            ],
            category: .upcoming,
            isFavouritesOnly: false
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                emptyEntry(
                    date: inHalfAnHour,
                    accessibleSummary: "no upcoming events",
                    category: .upcoming,
                    isFavouritesOnly: false
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
        
        let expectedSnapshotEntry = emptyEntry(
            date: now,
            accessibleSummary: "no upcoming events",
            category: .upcoming,
            isFavouritesOnly: false
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
        
        func proposedEntryStartTime(forEventsClustereredAt clusterTime: Date) -> Date {
            clusterTime
        }
        
    }
    
    // swiftlint:disable function_body_length
    func testDoesNotIncludeEventsThatAreRejectedByFilteringPolicy() {
        let firstEvent = event(id: "1", title: "A Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        let secondEvent = event(id: "2", title: "B Event", location: "Location", startTime: now, endTime: inHalfAnHour)
        let thirdEvent = event(id: "3", title: "C Event", location: "Location", startTime: now, endTime: inOneHour)
        
        let fourthEvent = event(
            id: "4",
            title: "D Event",
            location: "Location",
            startTime: inHalfAnHour,
            endTime: inOneHour
        )
        
        let fifthEvent = event(
            id: "5",
            title: "E Event",
            location: "Location",
            startTime: inHalfAnHour,
            endTime: inOneHour
        )

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
            accessibleSummary: "3 upcoming events",
            events: [
                expectedViewModel(for: firstEvent),
                expectedViewModel(for: secondEvent),
                expectedViewModel(for: fourthEvent)
            ],
            category: .upcoming,
            isFavouritesOnly: false
        )
        
        let secondExpectedSnapshotEntry = eventsEntry(
            date: inHalfAnHour,
            accessibleSummary: "1 upcoming event",
            events: [
                expectedViewModel(for: fourthEvent)
            ],
            category: .upcoming,
            isFavouritesOnly: false
        )
        
        let expected = EventsTimeline(
            snapshot: firstExpectedSnapshotEntry,
            entries: [
                firstExpectedSnapshotEntry,
                secondExpectedSnapshotEntry,
                emptyEntry(
                    date: inOneHour,
                    accessibleSummary: "no upcoming events",
                    category: .upcoming,
                    isFavouritesOnly: false
                )
            ]
        )
        
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(firstExpectedSnapshotEntry, actual?.snapshot)
    }
    
    func testStartingTimelineBeforeFirstEvent() {
        let (inTheFuture, inTheFuturePlusHalfAnHour) = (now.unsafelyUnwrapped, now.addingTimeInterval(3600 / 2))
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

        let expectedSnapshotEntry = emptyEntry(
            date: now,
            accessibleSummary: "no upcoming favourite events",
            category: .upcoming,
            isFavouritesOnly: true
        )
        
        let expectedEventEntry = eventsEntry(
            date: inTheFuture,
            accessibleSummary: "1 upcoming favourite event",
            events: [
                expectedViewModel(for: event)
            ],
            category: .upcoming,
            isFavouritesOnly: true
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                expectedEventEntry,
                emptyEntry(
                    date: inTheFuturePlusHalfAnHour,
                    accessibleSummary: "no upcoming favourite events",
                    category: .upcoming,
                    isFavouritesOnly: true
                )
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
        
        let expectedSnapshotEntry = emptyEntry(
            date: now,
            accessibleSummary: "no upcoming favourite events",
            category: .upcoming,
            isFavouritesOnly: true
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
        let shiftEntriesBackPolicy = ShiftEntriesBackTimelineFilteringPolicy(
            expectedFilteringTime: expectedFilteringTime,
            shiftEntriesBackBy: oneHour
        )
        
        let repository = StubEventsRepository(events: [event])
        setUpController(repository: repository, filteringPolicy: shiftEntriesBackPolicy)
        
        let actual = makeTimeline(timelineStartDate: now, isFavouritesOnly: true)
        
        let expectedSnapshotEntry = eventsEntry(
            date: now.addingTimeInterval(-oneHour),
            accessibleSummary: "1 upcoming favourite event",
            events: [
                expectedViewModel(for: event)
            ],
            category: .upcoming,
            isFavouritesOnly: true
        )
        
        let expected = EventsTimeline(
            snapshot: expectedSnapshotEntry,
            entries: [
                expectedSnapshotEntry,
                emptyEntry(
                    date: inHalfAnHour,
                    accessibleSummary: "no upcoming favourite events",
                    category: .upcoming,
                    isFavouritesOnly: true
                )
            ]
        )
        
        XCTAssertEqual(expected, actual)
        XCTAssertEqual(expectedSnapshotEntry, actual?.snapshot)
    }
    
}
