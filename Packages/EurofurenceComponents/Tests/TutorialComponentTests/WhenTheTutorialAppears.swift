import TutorialComponent
import XCTest

class WhenTheTutorialAppears: XCTestCase {

    var context: TutorialModuleTestBuilder.Context!

    override func setUp() {
        super.setUp()
        context = TutorialModuleTestBuilder().build()
    }

    func testItShouldBeToldToShowTheTutorialPage() {
        XCTAssertTrue(context.tutorial.wasToldToShowTutorialPage)
    }

    func testItShouldReturnTheViewControllerFromTheFactory() {
        XCTAssertEqual(context.tutorialViewController, context.tutorial)
    }

}
