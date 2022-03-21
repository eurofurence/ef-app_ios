import EurofurenceModel
import XCTest

class TheFirstTimeSyncFinishes_ApplicationShould: XCTestCase {

    func testRestrictEventsToTheFirstConDayWhenRunningBeforeConStarts() throws {
        let response = ModelCharacteristics.randomWithoutDeletions
        let firstDay = response.conferenceDays.changed.min(by: { $0.date < $1.date }).unsafelyUnwrapped
        let context = EurofurenceSessionTestBuilder().with(.distantPast).build()
        let schedule = context.eventsService.makeEventsSchedule()
        let delegate = CapturingScheduleDelegate()
        schedule.setDelegate(delegate)
        context.performSuccessfulSync(response: response)
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == firstDay.identifier })

        try EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(delegate.events, characterisedBy: expectedEvents)
    }

}
