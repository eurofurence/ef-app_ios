import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenRestrictingEventsToSpecificDay_ScheduleShould: XCTestCase {

    func testOnlyIncludeEventsRunningOnThatDay() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = FakeDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let schedule = context.eventsService.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        let randomDay = response.conferenceDays.changed.randomElement()
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == randomDay.element.identifier })
        schedule.restrictEvents(to: Day(date: randomDay.element.date))

        EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(delegate.events, characterisedBy: expectedEvents)
    }

    func testUpdateRestrictedScheduleWhenLaterSyncCompletes() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = FakeDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let schedule = context.eventsService.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        let randomDay = response.conferenceDays.changed.randomElement()
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == randomDay.element.identifier })
        schedule.restrictEvents(to: Day(date: randomDay.element.date))
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        schedule.setDelegate(delegate)

        EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(delegate.events, characterisedBy: expectedEvents)
    }

    func testRestrictEventsOnlyToTheLastSpecifiedRestrictedDay() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = FakeDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let schedule = context.eventsService.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        let randomDay = response.conferenceDays.changed.randomElement()
        let anotherRandomDay = response.conferenceDays.changed.randomElement()
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == randomDay.element.identifier })
        schedule.restrictEvents(to: Day(date: anotherRandomDay.element.date))
        schedule.restrictEvents(to: Day(date: randomDay.element.date))

        EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(delegate.events, characterisedBy: expectedEvents)
    }

}
