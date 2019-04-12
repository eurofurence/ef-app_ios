@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ScheduleInteractorShould: XCTestCase {

    var context: ScheduleInteractorTestBuilder.Context!
    var days: [Day]!
    var eventsService: FakeEventsService!

    override func setUp() {
        super.setUp()

        days = .random
        eventsService = FakeEventsService()
        context = ScheduleInteractorTestBuilder().with(eventsService).build()
    }

    func testAdaptDaysIntoViewModelsWithFriendlyDateTitles() {
        eventsService.simulateDaysChanged(days)
        context.makeViewModel()

        let expected = days.map(context.makeExpectedDayViewModel)

        XCTAssertEqual(expected, context.daysViewModels)
    }

    func testInformDelegateAboutLaterDayChanges() {
        context.makeViewModel()
        eventsService.simulateDaysChanged(days)

        let expected = days.map(context.makeExpectedDayViewModel)

        XCTAssertEqual(expected, context.daysViewModels)
    }

    func testProvideCurrentDayIndex() {
        let currentDay = days.randomElement()
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        eventsService.simulateDaysChanged(days)
        eventsService.simulateDayChanged(to: currentDay.element)
        context.makeViewModel()

        XCTAssertEqual(currentDay.index, context.currentDayIndex)
    }

    func testProvideZeroIndexWhenCurrentDayIsNotAvailable() {
        let context = ScheduleInteractorTestBuilder().build()
        context.makeViewModel()

        XCTAssertEqual(0, context.currentDayIndex)
    }

    func testTellScheduleToRestrictEventsToCurrentDayWhenAvailable() {
        let days = [Day].random
        let currentDay = days.randomElement()
        eventsService.simulateDaysChanged(days)
        eventsService.simulateDayChanged(to: currentDay.element)
        context.makeViewModel()

        XCTAssertEqual(currentDay.element, eventsService.lastProducedSchedule?.dayUsedToRestrictEvents)
    }

}
