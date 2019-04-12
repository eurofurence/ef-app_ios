@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenToldToRefresh_NewsInteractorShould: XCTestCase {

    func testTellRefreshServiceToRefresh() {
        let context = DefaultNewsInteractorTestBuilder().build()
        context.interactor.refresh()

        XCTAssertTrue(context.refreshService.toldToRefresh)
    }

}
