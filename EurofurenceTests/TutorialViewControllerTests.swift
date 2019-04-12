@testable import Eurofurence
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

    func testShowingTutorialPageShouldSetTheReturnedPageAsViewControllerOntoPageViewController() {
        guard let viewController = tutorialController.showTutorialPage() as? UIViewController else {
            XCTFail("Returned page was not a UIViewController subclass")
            return
        }

        XCTAssertEqual(true, tutorialController.viewControllers?.contains(viewController))
    }

}
