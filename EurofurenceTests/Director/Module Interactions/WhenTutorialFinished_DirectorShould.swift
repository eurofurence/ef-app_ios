import XCTest

class WhenTutorialFinished_DirectorShould: XCTestCase {

    func testShowThePreloadModule() {
        let context = ApplicationDirectorTestBuilder().build()
        context.rootModule.simulateTutorialShouldBePresented()
        context.tutorialModule.simulateTutorialFinished()

        XCTAssertEqual([context.preloadModule.stubInterface], context.rootNavigationController.viewControllers)
    }

}
