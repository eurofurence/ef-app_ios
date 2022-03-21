import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenAppLaunchesWhenClockReadsConferenceDay_ScheduleShould: XCTestCase {

    func testChangeToExpectedConDay() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomDay = syncResponse.conferenceDays.changed.randomElement().element
        let dataStore = InMemoryDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(randomDay.date).with(dataStore).build()
        let schedule = context.eventsService.loadSchedule()
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
        let schedule = context.eventsService.loadSchedule()
        let delegate = CapturingScheduleDelegate()
        schedule.setDelegate(delegate)

        DayAssertion()
            .assertDay(delegate.capturedCurrentDay, characterisedBy: randomDay)
    }

    func testProvideEventsForThatDay() throws {
        let response = ModelCharacteristics.randomWithoutDeletions
        let randomDay = response.conferenceDays.changed.randomElement().element
        let dataStore = InMemoryDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).with(randomDay.date).build()
        let schedule = context.eventsService.loadSchedule()
        let delegate = CapturingScheduleDelegate()
        schedule.setDelegate(delegate)
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == randomDay.identifier })

        try EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(delegate.events, characterisedBy: expectedEvents)
    }

}
