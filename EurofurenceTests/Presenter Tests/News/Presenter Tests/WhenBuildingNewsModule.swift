@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBuildingNewsModule: XCTestCase {

    func testTheInteractorDoesNotPrepareViewModel() {
        let newsInteractor = FakeNewsViewModelProducer()
        _ = NewsPresenterTestBuilder().with(newsInteractor).build()

        XCTAssertFalse(newsInteractor.didPrepareViewModel)
    }

}
