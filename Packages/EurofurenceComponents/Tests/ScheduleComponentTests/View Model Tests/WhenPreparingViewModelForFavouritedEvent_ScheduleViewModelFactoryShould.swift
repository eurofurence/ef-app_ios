import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTEurofurenceModel

class WhenPreparingViewModelForFavouritedEvent_ScheduleViewModelFactoryShould: XCTestCase {

    func testIndicateTheEventIsFavourited() {
        let eventsService = FakeScheduleRepository()
        eventsService.stubSomeFavouriteEvents()
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        context.makeViewModel()
        let eventViewModel = context.eventsViewModels.randomElement().element.events.randomElement().element

        XCTAssertTrue(eventViewModel.isFavourite)
    }

}
