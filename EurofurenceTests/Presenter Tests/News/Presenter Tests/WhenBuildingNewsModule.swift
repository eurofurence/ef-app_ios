@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBuildingNewsModule: XCTestCase {

    func testTheInteractorDoesNotPrepareViewModel() {
        let newsInteractor = FakeNewsInteractor()
        _ = NewsPresenterTestBuilder().with(newsInteractor).build()

        XCTAssertFalse(newsInteractor.didPrepareViewModel)
    }

}
