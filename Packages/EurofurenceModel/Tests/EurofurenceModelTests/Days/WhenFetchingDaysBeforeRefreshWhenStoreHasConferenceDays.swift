import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenFetchingDaysBeforeRefreshWhenStoreHasConferenceDays: XCTestCase {

    func testTheEventsFromTheStoreAreAdapted() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = InMemoryDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let delegate = CapturingScheduleDelegate()
        let schedule = context.eventsService.loadSchedule()
        schedule.setDelegate(delegate)

        DayAssertion()
            .assertDays(delegate.allDays, characterisedBy: response.conferenceDays.changed)
    }

}
