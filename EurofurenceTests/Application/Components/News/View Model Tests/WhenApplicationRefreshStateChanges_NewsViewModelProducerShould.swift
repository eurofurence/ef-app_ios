import XCTest

class WhenApplicationRefreshStateChanges_NewsViewModelProducerShould: XCTestCase {

    func testTellTheDelegateWhenTheAppBeginsRefreshing() {
        let context = DefaultNewsViewModelProducerTestBuilder().build()
        context.subscribeViewModelUpdates()
        context.refreshService.simulateRefreshBegan()

        XCTAssertTrue(context.delegate.toldRefreshDidBegin)
    }

    func testTellTheDelegateWhenTheAppFinishesRefreshing() {
        let context = DefaultNewsViewModelProducerTestBuilder().build()
        context.subscribeViewModelUpdates()
        context.refreshService.simulateRefreshFinished()

        XCTAssertTrue(context.delegate.toldRefreshDidFinish)
    }

}
