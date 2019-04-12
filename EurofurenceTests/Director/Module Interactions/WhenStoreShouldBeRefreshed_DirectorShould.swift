import XCTest

class WhenStoreShouldBeRefreshed_DirectorShould: XCTestCase {

    func testShowThePreloadModule() {
        let context = ApplicationDirectorTestBuilder().build()
        context.rootModule.simulateStoreShouldBeRefreshed()

        XCTAssertEqual([context.preloadModule.stubInterface], context.rootNavigationController.viewControllers)
    }

}
