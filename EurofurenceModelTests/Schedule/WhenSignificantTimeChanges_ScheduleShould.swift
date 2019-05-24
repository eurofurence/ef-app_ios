import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSignificantTimeChanges_ScheduleShould: XCTestCase {

    func testTellTheDelegateWhenMovingFromConDayToNonConDay() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomDay = syncResponse.conferenceDays.changed.randomElement().element
        let dataStore = InMemoryDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(randomDay.date).with(dataStore).build()
        let schedule = context.eventsService.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        context.clock.tickTime(to: .distantPast)
        context.simulateSignificantTimeChange()

        XCTAssertNil(delegate.capturedCurrentDay)
    }

}
