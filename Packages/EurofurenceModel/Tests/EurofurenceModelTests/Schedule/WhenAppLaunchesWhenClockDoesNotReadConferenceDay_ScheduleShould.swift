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

}
