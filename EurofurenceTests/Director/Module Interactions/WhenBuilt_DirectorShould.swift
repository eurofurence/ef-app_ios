import XCTest

class WhenBuilt_DirectorShould: XCTestCase {

    var context: ApplicationDirectorTestBuilder.Context!

    override func setUp() {
        super.setUp()
        context = ApplicationDirectorTestBuilder().build()
    }

    func testSetNavigationControllerAsRootOntoWindow() {
        XCTAssertTrue(context.windowWireframe.capturedRootInterface is UINavigationController)
    }

    func testNotShowNavigationBarForRootNavigationController() {
        XCTAssertTrue(context.rootNavigationController.isNavigationBarHidden)
    }

}
