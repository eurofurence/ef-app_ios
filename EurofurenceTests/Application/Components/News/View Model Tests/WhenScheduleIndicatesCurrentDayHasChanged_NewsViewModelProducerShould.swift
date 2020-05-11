import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenScheduleIndicatesCurrentDayHasChanged_NewsViewModelProducerShould: XCTestCase {

    func testRestrictTheEventsToTheCurrentDay() {
        let eventsService = FakeEventsService()
        let context = DefaultNewsViewModelProducerTestBuilder().with(eventsService).build()
        context.subscribeViewModelUpdates()
        let day = Day.random
        eventsService.lastProducedSchedule?.simulateDayChanged(to: day)

        XCTAssertEqual(day, eventsService.lastProducedSchedule?.dayUsedToRestrictEvents)
    }

    func testNotIncludeFavouritesSectionWhenDayIsNil() {
        let eventsService = FakeEventsService()
        let context = DefaultNewsViewModelProducerTestBuilder().with(eventsService).build()
        context.subscribeViewModelUpdates()
        eventsService.lastProducedSchedule?.simulateDayChanged(to: nil)

        context
            .assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasConventionCountdown()
            .hasAnnouncements()
            .verify()
    }

}
