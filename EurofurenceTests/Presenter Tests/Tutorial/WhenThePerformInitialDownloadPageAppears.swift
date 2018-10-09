//
//  WhenThePerformInitialDownloadPageAppears.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenThePerformInitialDownloadPageAppears: XCTestCase {
    
    var context: TutorialModuleTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = TutorialModuleTestBuilder()
            .with(UserAcknowledgedPushPermissions())
            .build()
    }
    
    func testShouldTellTheFirstTutorialPageToShowTheTitleForBeginningInitialLoad() {
        XCTAssertEqual(.tutorialInitialLoadTitle,
                       context.page.capturedPageTitle)
    }
    
    func testShouldTellTheFirstTutorialPageToShowTheDescriptionForBeginningInitialLoad() {
        XCTAssertEqual(.tutorialInitialLoadDescription,
                       context.page.capturedPageDescription)
    }
    
    func testShouldShowTheInformationImageForBeginningInitialLoad() {
        XCTAssertEqual(context.assets.initialLoadInformationAsset,
                       context.page.capturedPageImage)
    }
    
    func testShouldShowThePrimaryActionButtonForTheInitiateDownloadTutorialPage() {
        XCTAssertTrue(context.page.didShowPrimaryActionButton)
    }
    
    func testShouldTellTheTutorialPageToShowTheBeginDownloadTextOnThePrimaryActionButton() {
        XCTAssertEqual(.tutorialInitialLoadBeginDownload,
                       context.page.capturedPrimaryActionDescription)
    }
    
    func testTappingThePrimaryButtonOnTheInitiateDownloadPageShouldNotRequestPushPermissions() {
        context.tutorial.tutorialPage.simulateTappingSecondaryActionButton()
        context.page.simulateTappingPrimaryActionButton()
        
        XCTAssertFalse(context.pushRequesting.wasToldToRequestPushPermissions)
    }
    
    func testTappingThePrimaryButtonTellsTutorialDelegateTutorialFinished() {
        context.page.simulateTappingPrimaryActionButton()
        XCTAssertTrue(context.delegate.wasToldTutorialFinished)
    }
    
    func testTappingThePrimaryButtonTellsTutorialCompletionProvidingToMarkTutorialAsComplete() {
        context.page.simulateTappingPrimaryActionButton()
        XCTAssertTrue(context.tutorialStateProviding.didMarkTutorialAsComplete)
    }
    
    func testTappingThePrimaryButtonDoesNotTellAlertRouterToShowAlert() {
        context.page.simulateTappingPrimaryActionButton()
        XCTAssertFalse(context.alertRouter.didShowAlert)
    }
    
}
