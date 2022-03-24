import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenSignificantTimeChanges_ScheduleShould: XCTestCase {

    func testTellTheDelegateWhenMovingFromConDayToNonConDay() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomDay = syncResponse.conferenceDays.changed.randomElement().element
        let dataStore = InMemoryDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(randomDay.date).with(dataStore).build()
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let delegate = CapturingScheduleDelegate()
        schedule.setDelegate(delegate)
        context.clock.tickTime(to: .distantPast)
        context.simulateSignificantTimeChange()

        XCTAssertNil(delegate.capturedCurrentDay)
    }

}
