import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenRestrictingEventsToSpecificDay_ScheduleShould: XCTestCase {

    func testOnlyIncludeEventsRunningOnThatDay() throws {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = InMemoryDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let schedule = context.eventsService.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        let randomDay = response.conferenceDays.changed.randomElement()
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == randomDay.element.identifier })
        schedule.restrictEvents(to: Day(date: randomDay.element.date))

        try EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(delegate.events, characterisedBy: expectedEvents)
    }

    func testUpdateRestrictedScheduleWhenLaterSyncCompletes() throws {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = InMemoryDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let schedule = context.eventsService.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        let randomDay = response.conferenceDays.changed.randomElement()
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == randomDay.element.identifier })
        schedule.restrictEvents(to: Day(date: randomDay.element.date))
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
        let schedule = context.eventsService.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        let randomDay = response.conferenceDays.changed.randomElement()
        let anotherRandomDay = response.conferenceDays.changed.randomElement()
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == randomDay.element.identifier })
        schedule.restrictEvents(to: Day(date: anotherRandomDay.element.date))
        schedule.restrictEvents(to: Day(date: randomDay.element.date))

        try EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(delegate.events, characterisedBy: expectedEvents)
    }

}
