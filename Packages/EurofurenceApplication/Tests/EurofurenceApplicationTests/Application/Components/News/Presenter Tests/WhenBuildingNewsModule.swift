import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenBuildingNewsModule: XCTestCase {

    func testTheViewModelFactoryDoesNotPrepareViewModel() {
        let newsViewModelFactory = FakeNewsViewModelProducer()
        _ = NewsPresenterTestBuilder().with(newsViewModelFactory).build()

        XCTAssertFalse(newsViewModelFactory.didPrepareViewModel)
    }

}
