@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenViewModelIsToldToShowEventsForSpecificDay_ScheduleViewModelFactoryShould: XCTestCase {

    func testTellTheScheduleToRestrictEventsToSpecifiedDay() {
        let days: [Day] = .random
        let eventsService = FakeEventsService()
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        eventsService.simulateDaysChanged(days)
        let viewModel = context.makeViewModel()
        let randomDay = days.randomElement()
        viewModel?.showEventsForDay(at: randomDay.index)

        XCTAssertEqual(randomDay.element, eventsService.lastProducedSchedule?.dayUsedToRestrictEvents)
    }

}
