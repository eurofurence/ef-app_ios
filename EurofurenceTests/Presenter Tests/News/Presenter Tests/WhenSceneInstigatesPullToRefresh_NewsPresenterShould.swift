@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenSceneInstigatesPullToRefresh_NewsPresenterShould: XCTestCase {

    func testTellTheInteractorToRefresh() {
        let newsInteractor = FakeNewsInteractor()
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        context.simulateNewsSceneDidPerformRefreshAction()

        XCTAssertTrue(newsInteractor.didRefresh)
    }

    func testTellTheSceneToHideTheRefreshIndicatorWhenRefreshFinishes() {
        let newsInteractor = FakeNewsInteractor()
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        context.simulateNewsSceneDidPerformRefreshAction()
        newsInteractor.simulateRefreshFinished()

        XCTAssertTrue(context.newsScene.didHideRefreshIndicator)
    }

    func testTellTheSceneToShowTheRefreshIndicatorWhenRefreshBegins() {
        let newsInteractor = FakeNewsInteractor()
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        newsInteractor.simulateRefreshBegan()

        XCTAssertTrue(context.newsScene.didShowRefreshIndicator)
    }

}
