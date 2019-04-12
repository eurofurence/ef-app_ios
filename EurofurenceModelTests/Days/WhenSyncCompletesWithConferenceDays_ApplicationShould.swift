import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSyncCompletesWithConferenceDays_ApplicationShould: XCTestCase {

    func testProvideTheAdaptedDaysToObserversInDateOrder() {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let delegate = CapturingEventsScheduleDelegate()
        let schedule = context.eventsService.makeEventsSchedule()
        schedule.setDelegate(delegate)
        context.performSuccessfulSync(response: syncResponse)

        DayAssertion()
            .assertDays(delegate.allDays, characterisedBy: syncResponse.conferenceDays.changed)
    }

    func testNotUpdateTheDelegateIfTheDaysHaveNotChangedBetweenSyncs() {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let delegate = CapturingEventsScheduleDelegate()
        let schedule = context.eventsService.makeEventsSchedule()
        schedule.setDelegate(delegate)
        context.performSuccessfulSync(response: syncResponse)
        delegate.allDays.removeAll()
        context.performSuccessfulSync(response: syncResponse)

        XCTAssertTrue(delegate.allDays.isEmpty)
    }

    func testNotUpdateTheDelegateIfTheDaysHaveNotChangedBetweenDataStoreAndSync() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dataStore = FakeDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let delegate = CapturingEventsScheduleDelegate()
        let schedule = context.eventsService.makeEventsSchedule()
        schedule.setDelegate(delegate)
        delegate.allDays.removeAll()
        context.performSuccessfulSync(response: syncResponse)

        XCTAssertTrue(delegate.allDays.isEmpty)
    }

    func testProvideLateAddedObserversWithAdaptedDays() {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
        let delegate = CapturingEventsScheduleDelegate()
        let schedule = context.eventsService.makeEventsSchedule()
        schedule.setDelegate(delegate)

        DayAssertion()
            .assertDays(delegate.allDays, characterisedBy: syncResponse.conferenceDays.changed)
    }

}
