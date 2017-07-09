//
//  TutorialViewControllerTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class TutorialViewControllerTests: XCTestCase {

    var tutorialController: TutorialViewController!

    override func setUp() {
        super.setUp()

        let bundle = Bundle(for: TutorialViewController.self)
        let storyboard = UIStoryboard(name: "Tutorial", bundle: bundle)
        tutorialController = storyboard.instantiateInitialViewController() as? TutorialViewController
    }
    
    func testTheViewControllerShouldPreferTheLightStatusBarStyle() {
        XCTAssertEqual(tutorialController.preferredStatusBarStyle, .lightContent)
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
