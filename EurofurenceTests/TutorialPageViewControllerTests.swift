//
//  TutorialPageViewControllerTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class TutorialPageViewControllerTests: XCTestCase {

    var tutorialPageController: TutorialPageViewController!

    override func setUp() {
        super.setUp()

        let bundle = Bundle(for: TutorialPageViewController.self)
        let storyboard = UIStoryboard(name: "Tutorial", bundle: bundle)
        tutorialPageController = storyboard.instantiateViewController(withIdentifier: "TutorialPageViewController") as? TutorialPageViewController
        tutorialPageController.loadView()
    }
    
    func testTellingTheTutorialPageToShowTutorialInfoWithAnImageShouldSetTheImageOntoTheImageView() {
        let image = UIImage()
        let pageInfo = TutorialPageInfo(image: image, title: nil, description: nil)
        tutorialPageController.pageInfo = pageInfo

        XCTAssertEqual(image, tutorialPageController.tutorialPageImageView.image)
    }

    func testTellingTheTutorialPageToShowTutorialInfoWithTitleShouldSetTheTitleOntoTheTitleLabel() {
        let title = "Some page title"
        let pageInfo = TutorialPageInfo(image: nil, title: title, description: nil)
        tutorialPageController.pageInfo = pageInfo

        XCTAssertEqual(title, tutorialPageController.tutorialPageTitleLabel.text)
    }

    func testTellingTheTutorialPageToShowTutorialInfoWithDescriptionShouldSetTheDescriptionOntoTheDescriptionLabel() {
        let description = "Some page description"
        let pageInfo = TutorialPageInfo(image: nil, title: nil, description: description)
        tutorialPageController.pageInfo = pageInfo

        XCTAssertEqual(description, tutorialPageController.tutorialPageDescriptionLabel.text)
    }
    
}
