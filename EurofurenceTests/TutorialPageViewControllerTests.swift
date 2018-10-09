//
//  TutorialPageViewControllerTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class TutorialPageViewControllerTests: XCTestCase {

    var tutorialPageController: TutorialPageViewController!
    var delegate: CapturingTutorialPageSceneDelegate!

    override func setUp() {
        super.setUp()

        let bundle = Bundle(for: TutorialPageViewController.self)
        let storyboard = UIStoryboard(name: "Tutorial", bundle: bundle)
        tutorialPageController = storyboard.instantiateViewController(withIdentifier: "TutorialPageViewController") as? TutorialPageViewController
        tutorialPageController.loadView()
        
        delegate = CapturingTutorialPageSceneDelegate()
        tutorialPageController.tutorialPageSceneDelegate = delegate
    }

    func testTellingTheSceneToShowThePageTitleShouldSetItOntoTheTitleLabel() {
        let expectedTitle = "Some title"
        tutorialPageController.showPageTitle(expectedTitle)
        
        XCTAssertEqual(expectedTitle, tutorialPageController.tutorialPageTitleLabel.text)
    }
    
    func testTellingTheSceneToShowThePageDescriptionShouldSetItOntoTheDescriptionLabel() {
        let expectedDescription = "Some description"
        tutorialPageController.showPageDescription(expectedDescription)
        
        XCTAssertEqual(expectedDescription, tutorialPageController.tutorialPageDescriptionLabel.text)
    }
    
    func testTellingTheSceneToShowThePageImageShouldSetItOntoTheImageView() {
        let expectedImage = UIImage()
        tutorialPageController.showPageImage(expectedImage)
        
        XCTAssertEqual(expectedImage, tutorialPageController.tutorialPageImageView.image)
    }
    
    func testThePrimaryActionButtonShouldBeHidden() {
        XCTAssertTrue(tutorialPageController.primaryActionButton.isHidden)
    }
    
    func testTellingTheSceneToShowThePrimaryActionButtonShouldShowIt() {
        tutorialPageController.showPrimaryActionButton()
        XCTAssertFalse(tutorialPageController.primaryActionButton.isHidden)
    }
    
    func testTellingTheSceneToShowThePrimaryActionDescriptionShouldSetItOntoThePrimaryActionButton() {
        let primaryActionDescription = "Do voodoo"
        tutorialPageController.showPrimaryActionDescription(primaryActionDescription)
        
        XCTAssertEqual(primaryActionDescription, tutorialPageController.primaryActionButton.title(for: .normal))
    }
    
    func testTheSecondaryActionButtonShouldBeHidden() {
        XCTAssertTrue(tutorialPageController.secondaryActionButton.isHidden)
    }
    
    func testTellingTheSceneToShowTheSecondaryActionButtonShouldShowIt() {
        tutorialPageController.showSecondaryActionButton()
        XCTAssertFalse(tutorialPageController.secondaryActionButton.isHidden)
    }
    
    func testTellingTheSceneToShowTheSecondaryActionDescriptionShouldSetItOntoThePrimaryActionButton() {
        let secondaryActionDescription = "Do voodoo"
        tutorialPageController.showSecondaryActionDescription(secondaryActionDescription)
        
        XCTAssertEqual(secondaryActionDescription, tutorialPageController.secondaryActionButton.title(for: .normal))
    }
    
    func testTappingThePrimaryActionButtonShouldTellTheDelegateAboutIt() {
        tutorialPageController.primaryActionButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(delegate.primaryActionButtonTapped)
    }
    
    func testTappingTheSecondaryActionButtonShouldTellTheDelegateAboutIt() {
        tutorialPageController.secondaryActionButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(delegate.secondaryActionButtonTapped)
    }

    func testTappingTheSecondaryActionButtonShouldNotTellTheDelegateAboutTappingThePrimaryActionButton() {
        tutorialPageController.secondaryActionButton.sendActions(for: .touchUpInside)
        XCTAssertFalse(delegate.primaryActionButtonTapped)
    }

}
