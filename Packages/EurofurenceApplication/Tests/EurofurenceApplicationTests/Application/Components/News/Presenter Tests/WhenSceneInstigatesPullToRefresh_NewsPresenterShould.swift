import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenSceneInstigatesPullToRefresh_NewsPresenterShould: XCTestCase {

    func testTellTheViewModelFactoryToRefresh() {
        let newsViewModelFactory = FakeNewsViewModelProducer()
        let context = NewsPresenterTestBuilder().with(newsViewModelFactory).build()
        context.simulateNewsSceneDidLoad()
        context.simulateNewsSceneDidPerformRefreshAction()

        XCTAssertTrue(newsViewModelFactory.didRefresh)
    }

    func testTellTheSceneToHideTheRefreshIndicatorWhenRefreshFinishes() {
        let newsViewModelFactory = FakeNewsViewModelProducer()
        let context = NewsPresenterTestBuilder().with(newsViewModelFactory).build()
        context.simulateNewsSceneDidLoad()
        context.simulateNewsSceneDidPerformRefreshAction()
        newsViewModelFactory.simulateRefreshFinished()

        XCTAssertTrue(context.newsScene.didHideRefreshIndicator)
    }

    func testTellTheSceneToShowTheRefreshIndicatorWhenRefreshBegins() {
        let newsViewModelFactory = FakeNewsViewModelProducer()
        let context = NewsPresenterTestBuilder().with(newsViewModelFactory).build()
        context.simulateNewsSceneDidLoad()
        newsViewModelFactory.simulateRefreshBegan()

        XCTAssertTrue(context.newsScene.didShowRefreshIndicator)
    }

}
