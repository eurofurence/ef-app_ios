import EurofurenceModel
import XCTest

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
    
    private struct SpecificEventSpecification: Specification {
        
        let identifier: EventIdentifier
        
        func isSatisfied(by element: Event) -> Bool {
            element.identifier == identifier
        }
        
    }
    
}
