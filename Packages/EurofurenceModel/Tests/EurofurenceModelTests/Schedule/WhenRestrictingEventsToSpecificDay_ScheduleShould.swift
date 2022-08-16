import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenRestrictingEventsToSpecificDay_ScheduleShould: XCTestCase {

    func testOnlyIncludeEventsRunningOnThatDay() throws {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = InMemoryDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let delegate = CapturingScheduleDelegate()
        schedule.setDelegate(delegate)
        let randomDay = response.conferenceDays.changed.randomElement().element
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == randomDay.identifier })
        let specification = EventsOccurringOnDaySpecification(
            day: Day(date: randomDay.date, identifier: randomDay.identifier)
        )
        
        schedule.filterSchedule(to: specification)

        try EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(delegate.events, characterisedBy: expectedEvents)
    }

    func testUpdateRestrictedScheduleWhenLaterSyncCompletes() throws {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = InMemoryDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let delegate = CapturingScheduleDelegate()
        let randomDay = response.conferenceDays.changed.randomElement().element
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == randomDay.identifier })
        let specification = EventsOccurringOnDaySpecification(
            day: Day(date: randomDay.date, identifier: randomDay.identifier)
        )
        
        schedule.filterSchedule(to: specification)
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        schedule.setDelegate(delegate)

        try EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(delegate.events, characterisedBy: expectedEvents)
    }

    func testRestrictEventsOnlyToTheLastSpecifiedRestrictedDay() throws {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = InMemoryDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let delegate = CapturingScheduleDelegate()
        schedule.setDelegate(delegate)
        let randomDay = response.conferenceDays.changed.randomElement().element
        let anotherRandomDay = response.conferenceDays.changed.randomElement().element
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == randomDay.identifier })
        let firstSpecification = EventsOccurringOnDaySpecification(
            day: Day(date: anotherRandomDay.date, identifier: anotherRandomDay.identifier)
        )
        
        schedule.filterSchedule(to: firstSpecification)
        
        let secondSpecification = EventsOccurringOnDaySpecification(
            day: Day(date: randomDay.date, identifier: randomDay.identifier)
        )
        
        schedule.filterSchedule(to: secondSpecification)

        try EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(delegate.events, characterisedBy: expectedEvents)
    }

}
