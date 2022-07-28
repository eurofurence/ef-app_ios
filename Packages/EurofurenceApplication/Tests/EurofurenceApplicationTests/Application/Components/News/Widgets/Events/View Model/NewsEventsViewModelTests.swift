import Combine
import EurofurenceApplication
import EurofurenceModel
import EventDetailComponent
import XCTest
import XCTEurofurenceModel
import XCTRouter

class NewsEventsViewModelTests: XCTestCase {
    
    private var viewModel: DataSourceBackedEventsWidgetViewModel!
    private var eventsDataSource: ControllableEventsWidgetDataSource!
    private var fakeEventTimestampsFormatter: FakeDateFormatter!
    private var formatters: DataSourceBackedEventsWidgetViewModel.Formatters!
    private var router: FakeContentRouter!
    
    override func setUp() {
        super.setUp()
        
        fakeEventTimestampsFormatter = FakeDateFormatter()
        formatters = DataSourceBackedEventsWidgetViewModel.Formatters(eventTimestamps: fakeEventTimestampsFormatter)
        eventsDataSource = ControllableEventsWidgetDataSource()
        router = FakeContentRouter()
        
        viewModel = DataSourceBackedEventsWidgetViewModel(
            interactor: eventsDataSource,
            formatters: formatters,
            description: "Some Events",
            router: router
        )
    }
    
    func testExposesDescriptionAsTitle() {
        XCTAssertEqual("Some Events", viewModel.title)
    }
    
    func testInitiallyBindsNoContent() {
        XCTAssertEqual(0, viewModel.numberOfEvents)
    }
    
    func testWhenInteractorProvidesEvents_PreparesViewModelsForEvents() {
        let events: [FakeEvent] = [.random, .random]
        eventsDataSource.simulateEventsChanged(to: events)
        
        XCTAssertEqual(2, viewModel.numberOfEvents)
    }
    
    func testAdaptsBasicEventDetails() throws {
        let event = FakeEvent.random
        event.title = "Opening Ceremony"
        event.startDate = Date()
        event.endDate = event.startDate.addingTimeInterval(3600)
        event.room = Room(name: "EFO Stream")
        
        fakeEventTimestampsFormatter.stub("START", for: event.startDate)
        fakeEventTimestampsFormatter.stub("END", for: event.endDate)
        
        eventsDataSource.simulateEventsChanged(to: [event])
        
        let eventViewModel = try eventViewModel(at: 0)
        
        XCTAssertEqual("Opening Ceremony", eventViewModel.name)
        XCTAssertEqual("EFO Stream", eventViewModel.location)
        XCTAssertEqual("START", eventViewModel.startTime)
        XCTAssertEqual("END", eventViewModel.endTime)
    }
    
    func testAdaptsEventFavouriteState() throws {
        try assert(when: \FakeEvent.isFavourite, is: true, then: \.isFavourite, is: true)
        try assert(when: \FakeEvent.isFavourite, is: false, then: \.isFavourite, is: false)
    }
    
    func testAdaptsSponsorOnlyState() throws {
        try assert(when: \FakeEvent.isSponsorOnly, is: true, then: \.isSponsorOnly, is: true)
        try assert(when: \FakeEvent.isSponsorOnly, is: false, then: \.isSponsorOnly, is: false)
    }
    
    func testAdaptsSuperSponsorOnlyState() throws {
        try assert(when: \FakeEvent.isSuperSponsorOnly, is: true, then: \.isSuperSponsorOnly, is: true)
        try assert(when: \FakeEvent.isSuperSponsorOnly, is: false, then: \.isSuperSponsorOnly, is: false)
    }
    
    func testAdaptsArtShowState() throws {
        try assert(when: \FakeEvent.isArtShow, is: true, then: \.isArtShow, is: true)
        try assert(when: \FakeEvent.isArtShow, is: false, then: \.isArtShow, is: false)
    }
    
    func testAdaptsKageEventState() throws {
        try assert(when: \FakeEvent.isKageEvent, is: true, then: \.isKageEvent, is: true)
        try assert(when: \FakeEvent.isKageEvent, is: false, then: \.isKageEvent, is: false)
    }
    
    func testAdaptsDealersDenState() throws {
        try assert(when: \FakeEvent.isDealersDen, is: true, then: \.isDealersDen, is: true)
        try assert(when: \FakeEvent.isDealersDen, is: false, then: \.isDealersDen, is: false)
    }
    
    func testAdaptsMainStageState() throws {
        try assert(when: \FakeEvent.isMainStage, is: true, then: \.isMainStage, is: true)
        try assert(when: \FakeEvent.isMainStage, is: false, then: \.isMainStage, is: false)
    }
    
    func testAdaptsPhotoshootState() throws {
        try assert(when: \FakeEvent.isPhotoshoot, is: true, then: \.isPhotoshoot, is: true)
        try assert(when: \FakeEvent.isPhotoshoot, is: false, then: \.isPhotoshoot, is: false)
    }
    
    func testAdaptsRequiresFaceMaskState() throws {
        try assert(when: \FakeEvent.isFaceMaskRequired, is: true, then: \.isFaceMaskRequired, is: true)
        try assert(when: \FakeEvent.isFaceMaskRequired, is: false, then: \.isFaceMaskRequired, is: false)
    }
    
    func testEventTransitionsFromNotFavouriteToFavouriteNotifiesObserver() throws {
        let event = FakeEvent.random
        event.unfavourite()
        eventsDataSource.simulateEventsChanged(to: [event])
        
        let eventViewModel = try eventViewModel(at: 0)
        
        var notifiedDidChange = false
        let subscription = eventViewModel
            .objectDidChange
            .sink { (_) in
                notifiedDidChange = true
            }
        
        event.favourite()
        
        XCTAssertTrue(notifiedDidChange)
        
        subscription.cancel()
    }
    
    func testEventTransitionsFromFavouriteToNotFavouriteNotifiesObserver() throws {
        let event = FakeEvent.random
        event.favourite()
        eventsDataSource.simulateEventsChanged(to: [event])
        
        let eventViewModel = try eventViewModel(at: 0)
        
        var notifiedDidChange = false
        let subscription = eventViewModel
            .objectDidChange
            .sink { (_) in
                notifiedDidChange = true
            }
        
        event.unfavourite()
        
        XCTAssertTrue(notifiedDidChange)
        
        subscription.cancel()
    }
    
    func testEventsChangeOverTimePublishesObjectChanged() throws {
        var notifiedObjectDidChange = false

        let subscription = viewModel
            .objectDidChange
            .sink { (_) in
                notifiedObjectDidChange = true
            }

        eventsDataSource.simulateEventsChanged(to: [FakeEvent.random])
        
        XCTAssertTrue(notifiedObjectDidChange, "Upstream changes should propogate change notifications downstream")
        
        subscription.cancel()
    }
    
    func testSelectingEvent() {
        let events: [FakeEvent] = [.random, .random]
        eventsDataSource.simulateEventsChanged(to: events)
        
        viewModel.eventSelected(at: 1)
        
        let expected = EventRouteable(identifier: events[1].identifier)
        
        router.assertRouted(to: expected)
    }
    
    private func eventViewModel(at index: Int) throws -> EventViewModelAdapter {
        struct EventNotProduced: Error { }
        guard viewModel.numberOfEvents > 0 else { throw EventNotProduced() }
        
        return viewModel.event(at: index)
    }
    
    private func assert<T, U>(
        when eventKeyPath: WritableKeyPath<FakeEvent, T>,
        `is` value: T,
        then viewModelKeyPath: KeyPath<EventViewModelAdapter, U>,
        `is` expected: U,
        line: UInt = #line
    ) throws where U: Equatable {
        var event = FakeEvent.random
        event[keyPath: eventKeyPath] = value
        eventsDataSource.simulateEventsChanged(to: [event])
        let eventViewModel = try self.eventViewModel(at: 0)
        let actual = eventViewModel[keyPath: viewModelKeyPath]
        
        XCTAssertEqual(expected, actual, "State does not align with model", line: line)
    }
    
    private class ControllableEventsWidgetDataSource: EventsWidgetDataSource {
        
        typealias Publisher = PassthroughSubject<[Event], Never>
        
        var events = Publisher()
        
        func simulateEventsChanged(to events: [Event]) {
            self.events.send(events)
        }
        
    }
    
}
