import EurofurenceApplication
import EurofurenceModel
import XCTest

class TutorialViewControllerTests: XCTestCase {

    var tutorialController: TutorialViewController!

    override func setUp() {
        super.setUp()

        tutorialController = StoryboardTutorialSceneFactory().makeTutorialScene() as? TutorialViewController
    }

    func testTheViewControllerShouldPreferTheLightStatusBarStyle() {
        XCTAssertEqual(tutorialController.preferredStatusBarStyle, .lightContent)
    }

    func testTheViewControllerShouldUseTheScrollingPagingStyle() {
        XCTAssertEqual(tutorialController.transitionStyle, .scroll)
    }

    func testShowingTutorialPageShouldReturnTutorialPageViewController() {
        let page = tutorialController.showTutorialPage()
        XCTAssertTrue(page is TutorialPageViewController)
    }

    func testShowingTutorialPageShouldReturnTutorialPageViewControllerFromStoryboard() {
        let viewController = tutorialController.showTutorialPage() as? UIViewController
        XCTAssertNotNil(viewController?.storyboard)
    }

    func testShowingTutorialPageShouldSetTheReturnedPageAsViewControllerOntoPageViewController() throws {
        let viewController = try XCTUnwrap(tutorialController.showTutorialPage() as? UIViewController)
        XCTAssertEqual(true, tutorialController.viewControllers?.contains(viewController))
    }

}
