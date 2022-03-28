import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenScheduleIndicatesCurrentDayHasChanged_NewsViewModelProducerShould: XCTestCase {

    func testRestrictTheEventsToTheCurrentDay() {
        let eventsService = FakeScheduleRepository()
        let context = DefaultNewsViewModelProducerTestBuilder().with(eventsService).build()
        context.subscribeViewModelUpdates()
        let day = Day.random
        eventsService.lastProducedSchedule?.simulateDayChanged(to: day)

        XCTAssertEqual(day, eventsService.lastProducedSchedule?.dayUsedToRestrictEvents)
    }

    func testNotIncludeFavouritesSectionWhenDayIsNil() throws {
        let eventsService = FakeScheduleRepository()
        let context = DefaultNewsViewModelProducerTestBuilder().with(eventsService).build()
        context.subscribeViewModelUpdates()
        eventsService.lastProducedSchedule?.simulateDayChanged(to: nil)

        try context
            .assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasConventionCountdown()
            .hasAnnouncements()
            .verify()
    }

}
