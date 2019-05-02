import XCTest

class WhenPreloadFails_DirectorShould: XCTestCase {

    func testShowTheTutorial() {
        let context = ApplicationDirectorTestBuilder().build()
        context.rootModule.simulateTutorialShouldBePresented()
        context.tutorialModule.simulateTutorialFinished()
        context.preloadModule.simulatePreloadCancelled()

        XCTAssertEqual(context.tutorialModule.stubInterface, context.windowWireframe.capturedRootInterface)
    }

}
