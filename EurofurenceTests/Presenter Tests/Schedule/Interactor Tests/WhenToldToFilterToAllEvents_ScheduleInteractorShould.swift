@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenToldToFilterToAllEvents_ScheduleInteractorShould: XCTestCase {

    func testTellTheSearchControllerToLifeTheFavouritesRestriction() {
        let eventsService = FakeEventsService()
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        let searchViewModel = context.makeSearchViewModel()
        searchViewModel?.filterToAllEvents()

        XCTAssertEqual(true, eventsService.lastProducedSearchController?.didLiftFavouritesSearchRestriction)
    }

}
