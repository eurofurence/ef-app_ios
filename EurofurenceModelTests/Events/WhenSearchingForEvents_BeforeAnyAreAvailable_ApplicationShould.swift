import EurofurenceModel
import XCTest

class WhenSearchingForEvents_BeforeAnyAreAvailable_ApplicationShould: XCTestCase {

    func testProduceEmptyResults() {
        let context = EurofurenceSessionTestBuilder().build()
        let eventsSearchController = context.eventsService.makeEventsSearchController()
        let delegate = CapturingEventsSearchControllerDelegate()
        eventsSearchController.setResultsDelegate(delegate)
        eventsSearchController.changeSearchTerm(.random)

        XCTAssertTrue(delegate.toldSearchResultsUpdatedToEmptyArray)
    }

}
