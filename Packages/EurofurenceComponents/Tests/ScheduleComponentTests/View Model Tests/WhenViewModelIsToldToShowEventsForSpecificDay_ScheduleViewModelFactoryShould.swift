import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTEurofurenceModel

class WhenViewModelIsToldToShowEventsForSpecificDay_ScheduleViewModelFactoryShould: XCTestCase {

    func testTellTheScheduleToRestrictEventsToSpecifiedDay() {
        let days: [Day] = .random
        let eventsService = FakeScheduleRepository()
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        eventsService.simulateDaysChanged(days)
        let viewModel = context.makeViewModel()
        let randomDay = days.randomElement()
        viewModel?.showEventsForDay(at: randomDay.index)

        XCTAssertEqual(randomDay.element, eventsService.lastProducedSchedule?.dayUsedToRestrictEvents)
    }

}
