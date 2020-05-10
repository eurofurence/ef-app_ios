@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenToldToRefresh_NewsViewModelProducerShould: XCTestCase {

    func testTellRefreshServiceToRefresh() {
        let context = DefaultNewsViewModelProducerTestBuilder().build()
        context.interactor.refresh()

        XCTAssertTrue(context.refreshService.toldToRefresh)
    }

}
