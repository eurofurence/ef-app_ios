@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenToldToFavouriteEvent_ScheduleInteractorShould: XCTestCase {

    func testFavouriteTheEvent() {
        let eventsService = FakeEventsService()
        let events = [FakeEvent].random
        eventsService.allEvents = events
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        let viewModel = context.makeViewModel()
        let randomGroup = context.eventsViewModels.randomElement()
        let randomEvent = randomGroup.element.events.randomElement()
        let originalEvent = events.first(where: { $0.title == randomEvent.element.title })
        let indexPath = IndexPath(item: randomEvent.index, section: randomGroup.index)
        viewModel?.favouriteEvent(at: indexPath)

        XCTAssertEqual(originalEvent?.favouritedState, .favourited)
    }

}
