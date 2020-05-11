import Eurofurence
import EurofurenceModel
import XCTest

class WhenBuildingNewsPresenterForUnauthenticatedUser: XCTestCase {

    var context: NewsPresenterTestBuilder.Context!

    override func setUp() {
        super.setUp()
        context = NewsPresenterTestBuilder().build()
    }

    func testTheSceneIsReturnedFromTheModuleFactory() {
        XCTAssertEqual(context.newsScene, context.sceneFactory.stubbedScene)
    }

    func testTheSceneIsToldToShowTheNewsTitle() {
        XCTAssertEqual(.news, context.newsScene.capturedTitle)
    }

}
