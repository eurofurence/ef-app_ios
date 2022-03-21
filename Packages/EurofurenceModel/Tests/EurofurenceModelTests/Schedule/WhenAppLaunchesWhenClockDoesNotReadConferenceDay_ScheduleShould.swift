import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenAppLaunchesWhenClockDoesNotReadConferenceDay_ScheduleShould: XCTestCase {

    func testChangeToNilConDay() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dataStore = InMemoryDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(.distantPast).with(dataStore).build()
        let schedule = context.eventsService.loadSchedule()
        let delegate = CapturingScheduleDelegate()
        schedule.setDelegate(delegate)

        XCTAssertTrue(delegate.toldChangedToNilDay)
    }

    func testRestrictEventsToTheFirstConferenceDay() throws {
        let response = ModelCharacteristics.randomWithoutDeletions
        let firstDay = response.conferenceDays.changed.min(by: { $0.date < $1.date }).unsafelyUnwrapped
        let dataStore = InMemoryDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).with(.distantPast).build()
        let schedule = context.eventsService.loadSchedule()
        let delegate = CapturingScheduleDelegate()
        schedule.setDelegate(delegate)
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == firstDay.identifier })

        try EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(delegate.events, characterisedBy: expectedEvents)
    }

}
