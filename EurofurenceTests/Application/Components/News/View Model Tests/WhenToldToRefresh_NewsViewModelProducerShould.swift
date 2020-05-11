import Eurofurence
import EurofurenceModel
import XCTest

class WhenToldToRefresh_NewsViewModelProducerShould: XCTestCase {

    func testTellRefreshServiceToRefresh() {
        let context = DefaultNewsViewModelProducerTestBuilder().build()
        context.viewModelFactory.refresh()

        XCTAssertTrue(context.refreshService.toldToRefresh)
    }

}
