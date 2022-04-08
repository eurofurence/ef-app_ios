import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenAppLaunchesWhenClockReadsConferenceDay_ScheduleShould: XCTestCase {

    func testChangeToExpectedConDay() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomDay = syncResponse.conferenceDays.changed.randomElement().element
        let dataStore = InMemoryDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(randomDay.date).with(dataStore).build()
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let delegate = CapturingScheduleDelegate()
        schedule.setDelegate(delegate)

        DayAssertion()
            .assertDay(delegate.capturedCurrentDay, characterisedBy: randomDay)
    }

    func testPermitFuzzyMatchingAgainstHoursMinutesAndSecondsWithinDay() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomDay = syncResponse.conferenceDays.changed.randomElement().element
        var randomDayComponents = Calendar.current.dateComponents(in: .current, from: randomDay.date)
        randomDayComponents.hour = .random(upperLimit: 22)
        randomDayComponents.minute = .random(upperLimit: 58)
        randomDayComponents.second = .random(upperLimit: 58)
        let sameDayAsRandomDayButDifferentTime = randomDayComponents.date.unsafelyUnwrapped
        let dataStore = InMemoryDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(sameDayAsRandomDayButDifferentTime).with(dataStore).build()
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let delegate = CapturingScheduleDelegate()
        schedule.setDelegate(delegate)

        DayAssertion()
            .assertDay(delegate.capturedCurrentDay, characterisedBy: randomDay)
    }

}
