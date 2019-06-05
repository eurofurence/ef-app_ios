import EurofurenceModel
import XCTest

class TheFirstTimeSyncFinishes_ApplicationShould: XCTestCase {

    func testRestrictEventsToTheFirstConDayWhenRunningBeforeConStarts() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let firstDay = unwrap(response.conferenceDays.changed.sorted(by: { $0.date < $1.date }).first)
        let context = EurofurenceSessionTestBuilder().with(.distantPast).build()
        let schedule = context.eventsService.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        context.performSuccessfulSync(response: response)
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == firstDay.identifier })

        EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(delegate.events, characterisedBy: expectedEvents)
    }

}
