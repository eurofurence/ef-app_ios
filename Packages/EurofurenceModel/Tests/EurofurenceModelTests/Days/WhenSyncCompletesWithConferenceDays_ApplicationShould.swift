import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenSyncCompletesWithConferenceDays_ApplicationShould: XCTestCase {

    func testProvideTheAdaptedDaysToObserversInDateOrder() {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let delegate = CapturingScheduleDelegate()
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        schedule.setDelegate(delegate)
        context.performSuccessfulSync(response: syncResponse)

        DayAssertion()
            .assertDays(delegate.allDays, characterisedBy: syncResponse.conferenceDays.changed)
    }
    
    func testUpdateDelegateWithTheCurrentDayAfterRefreshConcludes() {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let delegate = CapturingScheduleDelegate()
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        schedule.setDelegate(delegate)
        delegate.toldChangedToNilDay = false
        context.performSuccessfulSync(response: syncResponse)

        XCTAssertTrue(delegate.toldChangedToNilDay)
    }

    func testNotUpdateTheDelegateIfTheDaysHaveNotChangedBetweenSyncs() {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let delegate = CapturingScheduleDelegate()
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        schedule.setDelegate(delegate)
        context.performSuccessfulSync(response: syncResponse)
        delegate.allDays.removeAll()
        context.performSuccessfulSync(response: syncResponse)

        XCTAssertTrue(delegate.allDays.isEmpty)
    }

    func testNotUpdateTheDelegateIfTheDaysHaveNotChangedBetweenDataStoreAndSync() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dataStore = InMemoryDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let delegate = CapturingScheduleDelegate()
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        schedule.setDelegate(delegate)
        delegate.allDays.removeAll()
        context.performSuccessfulSync(response: syncResponse)

        XCTAssertTrue(delegate.allDays.isEmpty)
    }

    func testProvideLateAddedObserversWithAdaptedDays() {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
        let delegate = CapturingScheduleDelegate()
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        schedule.setDelegate(delegate)

        DayAssertion()
            .assertDays(delegate.allDays, characterisedBy: syncResponse.conferenceDays.changed)
    }

}
