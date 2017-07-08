//
//  TutorialPageViewControllerTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingAction: TutorialAction {

    private(set) var didRun = false
    func run() {
        didRun = true
    }

}

class TutorialPageViewControllerTests: XCTestCase {

    var tutorialPageController: TutorialPageViewController!

    override func setUp() {
        super.setUp()

        let bundle = Bundle(for: TutorialPageViewController.self)
        let storyboard = UIStoryboard(name: "Tutorial", bundle: bundle)
        tutorialPageController = storyboard.instantiateViewController(withIdentifier: "TutorialPageViewController") as? TutorialPageViewController
        tutorialPageController.loadView()
    }

    private func makeTutorialPageInfo(image: UIImage? = nil,
                                      title: String? = nil,
                                      description: String? = nil,
                                      primaryAction: TutorialPageAction? = nil) -> TutorialPageInfo {
        return TutorialPageInfo(image: image,
                                title: title,
                                description: description,
                                primaryAction: primaryAction)
    }
    
    func testTellingTheTutorialPageToShowTutorialInfoWithAnImageShouldSetTheImageOntoTheImageView() {
        let image = UIImage()
        let pageInfo = makeTutorialPageInfo(image: image)
        tutorialPageController.pageInfo = pageInfo

        XCTAssertEqual(image, tutorialPageController.tutorialPageImageView.image)
    }

    func testTellingTheTutorialPageToShowTutorialInfoWithTitleShouldSetTheTitleOntoTheTitleLabel() {
        let title = "Some page title"
        let pageInfo = makeTutorialPageInfo(title: title)
        tutorialPageController.pageInfo = pageInfo

        XCTAssertEqual(title, tutorialPageController.tutorialPageTitleLabel.text)
    }

    func testTellingTheTutorialPageToShowTutorialInfoWithDescriptionShouldSetTheDescriptionOntoTheDescriptionLabel() {
        let description = "Some page description"
        let pageInfo = makeTutorialPageInfo(description: description)
        tutorialPageController.pageInfo = pageInfo

        XCTAssertEqual(description, tutorialPageController.tutorialPageDescriptionLabel.text)
    }

    func testThePrimaryActionButtonShouldBeHiddenByDefault() {
        XCTAssertTrue(tutorialPageController.primaryActionButton.isHidden)
    }

    func testTellingTheTutorialPageToShowTutorialInfoWithPrimaryActionShouldShowThePrimaryActionButton() {
        let primaryAction = TutorialPageAction(actionDescription: "", action: CapturingAction())
        let pageInfo = makeTutorialPageInfo(primaryAction: primaryAction)
        tutorialPageController.pageInfo = pageInfo

        XCTAssertFalse(tutorialPageController.primaryActionButton.isHidden)
    }

    func testTellingTheTutorialPageToShowTutorialInfoWithPrimaryActionThenAnotherInfoWithoutPrimaryActionShouldHideThePrimaryActionButton() {
        let primaryAction = TutorialPageAction(actionDescription: "", action: CapturingAction())
        let pageInfo = makeTutorialPageInfo(primaryAction: primaryAction)
        tutorialPageController.pageInfo = pageInfo
        tutorialPageController.pageInfo = makeTutorialPageInfo()

        XCTAssertTrue(tutorialPageController.primaryActionButton.isHidden)
    }

    func testTellingTheTutorialPageToShowTutorialInfoWithPrimaryActionShouldSetTheActionNameOntoThePrimaryActionButton() {
        let primaryActionDescription = "Do some voodoo"
        let primaryAction = TutorialPageAction(actionDescription: primaryActionDescription, action: CapturingAction())
        let pageInfo = makeTutorialPageInfo(primaryAction: primaryAction)
        tutorialPageController.pageInfo = pageInfo

        XCTAssertEqual(primaryActionDescription, tutorialPageController.primaryActionButton.titleLabel?.text)
    }

    func testTellingTheTutorialPageToShowTutorialInfoWithPrimaryActionShouldInvokeTheActionWhenTappingTheButton() {
        let capturingAction = CapturingAction()
        let primaryAction = TutorialPageAction(actionDescription: "", action: capturingAction)
        let pageInfo = makeTutorialPageInfo(primaryAction: primaryAction)
        tutorialPageController.pageInfo = pageInfo
        tutorialPageController.primaryActionButton.sendActions(for: .touchUpInside)

        XCTAssertTrue(capturingAction.didRun)
    }
    
}
