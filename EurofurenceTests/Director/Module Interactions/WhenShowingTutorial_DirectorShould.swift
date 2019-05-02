import XCTest

class WhenShowingTutorial_DirectorShould: XCTestCase {

    func testSetTutorialInterfaceOntoNavigationController() {
        let context = ApplicationDirectorTestBuilder().build()
        context.rootModule.simulateTutorialShouldBePresented()

        XCTAssertEqual(context.tutorialModule.stubInterface, context.windowWireframe.capturedRootInterface)
    }

}
