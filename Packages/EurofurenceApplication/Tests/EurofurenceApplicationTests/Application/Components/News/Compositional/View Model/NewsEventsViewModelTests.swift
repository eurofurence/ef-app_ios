import Combine
import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class NewsEventsViewModelTests: XCTestCase {
    
    private var viewModel: EventsWidgetViewModel!
    private var eventsDataSource: ControllableEventsWidgetDataSource!
    private var fakeEventTimestampsFormatter: FakeDateFormatter!
    private var formatters: EventsWidgetViewModel.Formatters!
    
    override func setUp() {
        super.setUp()
        
        fakeEventTimestampsFormatter = FakeDateFormatter()
        formatters = EventsWidgetViewModel.Formatters(eventTimestamps: fakeEventTimestampsFormatter)
        eventsDataSource = ControllableEventsWidgetDataSource()
        viewModel = EventsWidgetViewModel(interactor: eventsDataSource, formatters: formatters)
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
        try assert(when: \FakeEvent.isFavourite, is: true, then: \EventViewModel.isFavourite, is: true)
        try assert(when: \FakeEvent.isFavourite, is: false, then: \EventViewModel.isFavourite, is: false)
    }
    
    func testAdaptsSponsorOnlyState() throws {
        try assert(when: \FakeEvent.isSponsorOnly, is: true, then: \EventViewModel.isSponsorOnly, is: true)
        try assert(when: \FakeEvent.isSponsorOnly, is: false, then: \EventViewModel.isSponsorOnly, is: false)
    }
    
    func testAdaptsSuperSponsorOnlyState() throws {
        try assert(when: \FakeEvent.isSuperSponsorOnly, is: true, then: \EventViewModel.isSuperSponsorOnly, is: true)
        try assert(when: \FakeEvent.isSuperSponsorOnly, is: false, then: \EventViewModel.isSuperSponsorOnly, is: false)
    }
    
    func testAdaptsArtShowState() throws {
        try assert(when: \FakeEvent.isArtShow, is: true, then: \EventViewModel.isArtShow, is: true)
        try assert(when: \FakeEvent.isArtShow, is: false, then: \EventViewModel.isArtShow, is: false)
    }
    
    func testAdaptsKageEventState() throws {
        try assert(when: \FakeEvent.isKageEvent, is: true, then: \EventViewModel.isKageEvent, is: true)
        try assert(when: \FakeEvent.isKageEvent, is: false, then: \EventViewModel.isKageEvent, is: false)
    }
    
    func testAdaptsDealersDenState() throws {
        try assert(when: \FakeEvent.isDealersDen, is: true, then: \EventViewModel.isDealersDen, is: true)
        try assert(when: \FakeEvent.isDealersDen, is: false, then: \EventViewModel.isDealersDen, is: false)
    }
    
    func testAdaptsMainStageState() throws {
        try assert(when: \FakeEvent.isMainStage, is: true, then: \EventViewModel.isMainStage, is: true)
        try assert(when: \FakeEvent.isMainStage, is: false, then: \EventViewModel.isMainStage, is: false)
    }
    
    func testAdaptsPhotoshootState() throws {
        try assert(when: \FakeEvent.isPhotoshoot, is: true, then: \EventViewModel.isPhotoshoot, is: true)
        try assert(when: \FakeEvent.isPhotoshoot, is: false, then: \EventViewModel.isPhotoshoot, is: false)
    }
    
    private func eventViewModel(at index: Int) throws -> EventViewModel {
        struct EventNotProduced: Error { }
        guard viewModel.numberOfEvents > 0 else { throw EventNotProduced() }
        
        return viewModel.event(at: index)
    }
    
    private func assert<T, U>(
        when eventKeyPath: WritableKeyPath<FakeEvent, T>,
        `is` value: T,
        then viewModelKeyPath: KeyPath<EventViewModel, U>,
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
