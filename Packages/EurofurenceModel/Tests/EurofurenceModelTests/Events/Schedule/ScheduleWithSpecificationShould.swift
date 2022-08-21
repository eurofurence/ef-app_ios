import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class ScheduleWithSpecificationShould: XCTestCase {
    
    func testOnlyReturnEventsSatisfiedBySpecification() throws {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let delegate = CapturingScheduleDelegate()
        schedule.setDelegate(delegate)
        let specification = SpecificEventSpecification(identifier: EventIdentifier(randomEvent.element.identifier))
        schedule.filterSchedule(to: specification)
        
        try EventAssertion(context: context, modelCharacteristics: syncResponse)
            .assertEvents(delegate.events, characterisedBy: [randomEvent.element])
    }
    
    func testOnlyReturnEventsSatisfiedBySpecification_LateBinding() throws {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let specification = SpecificEventSpecification(identifier: EventIdentifier(randomEvent.element.identifier))
        schedule.filterSchedule(to: specification)
        let delegate = CapturingScheduleDelegate()
        schedule.setDelegate(delegate)
        
        try EventAssertion(context: context, modelCharacteristics: syncResponse)
            .assertEvents(delegate.events, characterisedBy: [randomEvent.element])
    }
    
    func testUpdateResultsWhenEventsChange() throws {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        let context = EurofurenceSessionTestBuilder().build()
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let specification = SpecificEventSpecification(identifier: EventIdentifier(randomEvent.element.identifier))
        schedule.filterSchedule(to: specification)
        let delegate = CapturingScheduleDelegate()
        schedule.setDelegate(delegate)
        context.performSuccessfulSync(response: syncResponse)
        
        try EventAssertion(context: context, modelCharacteristics: syncResponse)
            .assertEvents(delegate.events, characterisedBy: [randomEvent.element])
    }
    
    func testUpdatesResultsWhenEventIsFavourited() throws {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let specification = IsFavouriteEventSpecification()
        schedule.filterSchedule(to: specification)
        let delegate = CapturingScheduleDelegate()
        schedule.setDelegate(delegate)
        let event = try XCTUnwrap(schedule.loadEvent(identifier: EventIdentifier(randomEvent.element.identifier)))
        event.favourite()
        
        try EventAssertion(context: context, modelCharacteristics: syncResponse)
            .assertEvents(delegate.events, characterisedBy: [randomEvent.element])
    }
    
    func testUpdatesResultsWhenEventIsUnfavourited() throws {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let specification = IsFavouriteEventSpecification()
        schedule.filterSchedule(to: specification)
        let delegate = CapturingScheduleDelegate()
        schedule.setDelegate(delegate)
        let event = try XCTUnwrap(schedule.loadEvent(identifier: EventIdentifier(randomEvent.element.identifier)))
        event.favourite()
        event.unfavourite()
        
        try EventAssertion(context: context, modelCharacteristics: syncResponse)
            .assertEvents(delegate.events, characterisedBy: [])
    }
    
    func testNotProvideDuplicateUpdatesWhenEventsHasNotChangedDuringUpdates() throws {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let delegate = JournallingScheduleDelegate()
        schedule.setDelegate(delegate)
        let specification = SpecificEventSpecification(identifier: EventIdentifier(randomEvent.element.identifier))
        schedule.filterSchedule(to: specification)
        
        let currentNumberOfUpdates = delegate.numberOfEventUpdates
        let event = try XCTUnwrap(schedule.loadEvent(identifier: EventIdentifier(randomEvent.element.identifier)))
        event.favourite()
        
        XCTAssertEqual(currentNumberOfUpdates, delegate.numberOfEventUpdates)
    }
    
    func testNotOverlyNotifyCurrentDayWhenItDoesNotChangeBetweenUpdates_BUG() throws {
        let response = ModelCharacteristics.randomWithoutDeletions
        let randomDay = response.conferenceDays.changed.randomElement().element
        let dataStore = InMemoryDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).with(randomDay.date).build()
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let delegate = JournallingScheduleDelegate()
        schedule.setDelegate(delegate)
        
        let currentNumberOfUpdates = delegate.numberOfCurrentDayUpdates
        let randomEvent = response.events.changed.randomElement()
        let event = try XCTUnwrap(schedule.loadEvent(identifier: EventIdentifier(randomEvent.element.identifier)))
        event.favourite()
        
        XCTAssertEqual(currentNumberOfUpdates, delegate.numberOfCurrentDayUpdates)
    }
    
    func testNotifyDelegateWhenSpecificationChanged() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let randomDay = response.conferenceDays.changed.randomElement().element
        let dataStore = InMemoryDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).with(randomDay.date).build()
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let delegate = JournallingScheduleDelegate()
        schedule.setDelegate(delegate)
        
        let specification = AlwaysPassesSpecification<Event>()
        schedule.filterSchedule(to: specification)
        
        XCTAssertEqual(specification.eraseToAnySpecification(), delegate.latestScheduleSpecification)
    }
    
    func testNotifyDelegateOfOriginalSpecification() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let randomDay = response.conferenceDays.changed.randomElement().element
        let dataStore = InMemoryDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).with(randomDay.date).build()
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let specification = AlwaysPassesSpecification<Event>()
        schedule.filterSchedule(to: specification)
        
        let delegate = JournallingScheduleDelegate()
        schedule.setDelegate(delegate)
        
        XCTAssertEqual(specification.eraseToAnySpecification(), delegate.latestScheduleSpecification)
    }
    
    private struct SpecificEventSpecification: Specification {
        
        let identifier: EventIdentifier
        
        func isSatisfied(by element: Event) -> Bool {
            element.identifier == identifier
        }
        
    }
    
    private class JournallingScheduleDelegate: CapturingScheduleDelegate {
        
        private(set) var numberOfEventUpdates = 0
        override func scheduleEventsDidChange(to events: [Event]) {
            super.scheduleEventsDidChange(to: events)
            numberOfEventUpdates += 1
        }
        
        private(set) var numberOfCurrentDayUpdates = 0
        override func currentEventDayDidChange(to day: Day?) {
            super.currentEventDayDidChange(to: day)
            numberOfCurrentDayUpdates += 1
        }
        
    }
    
}
