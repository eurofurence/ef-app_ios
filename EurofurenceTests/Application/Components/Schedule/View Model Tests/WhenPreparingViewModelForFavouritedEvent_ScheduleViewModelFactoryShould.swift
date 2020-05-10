@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModelForFavouritedEvent_ScheduleViewModelFactoryShould: XCTestCase {

    func testIndicateTheEventIsFavourited() {
        let eventsService = FakeEventsService()
        let events = [FakeEvent].random
        events.forEach({ $0.favourite() })
        eventsService.allEvents = events
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        context.makeViewModel()
        let eventViewModel = context.eventsViewModels.randomElement().element.events.randomElement().element

        XCTAssertTrue(eventViewModel.isFavourite)
    }

}
