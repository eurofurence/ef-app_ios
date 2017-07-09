//
//  WhenTheTutorialAppears.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenTheTutorialAppears: XCTestCase {

    private func showTutorial(_ items: [TutorialPageInfo] = []) -> (tutorial: CapturingTutorialScene,
                                                                    page: CapturingTutorialPageScene) {
        let tutorialRouter = CapturingTutorialRouter()
        let routers = StubRouters(tutorialRouter: tutorialRouter)
        let context = TestingApplicationContextBuilder()
            .forShowingTutorial()
            .withTutorialItems(items)
            .build()
        BootstrappingModule.bootstrap(context: context, routers: routers)

        return (tutorial: tutorialRouter.tutorialScene, page: tutorialRouter.tutorialScene.tutorialPage)
    }
    
    func testItShouldBeToldToShowTheTutorialPage() {
        let setup = showTutorial()
        XCTAssertTrue(setup.tutorial.wasToldToShowTutorialPage)
    }

    func testItShouldTellTheFirstTutorialPageToShowTheTitleFromTheFirstTutorialItem() {
        let expectedTitle = "Tutorial title"
        let firstTutorialItem = TutorialPageInfo(image: nil, title: expectedTitle, description: nil)
        let setup = showTutorial([firstTutorialItem])

        XCTAssertEqual(expectedTitle, setup.page.capturedPageTitle)
    }

    func testItShouldTellTheFirstTutorialPageToShowTheDescriptionFromTheFirstTutorialItem() {
        let expectedDescription = "Tutorial title"
        let firstTutorialItem = TutorialPageInfo(image: nil, title: nil, description: expectedDescription)
        let setup = showTutorial([firstTutorialItem])

        XCTAssertEqual(expectedDescription, setup.page.capturedPageDescription)
    }

    func testItShouldTellTheFirstTutorialPageToShowTheImageFromTheFirstTutorialItem() {
        let expectedImage = UIImage()
        let firstTutorialItem = TutorialPageInfo(image: expectedImage, title: nil, description: nil)
        let setup = showTutorial([firstTutorialItem])

        XCTAssertEqual(expectedImage, setup.page.capturedPageImage)
    }
    
    func testItShouldTellTheFirstTutorialPageToShowThePrimaryActionButtonWhenPrimaryActionAvailable() {
        let action = TutorialPageAction(actionDescription: "", action: CapturingAction())
        let firstTutorialItem = TutorialPageInfo(image: nil, title: nil, description: nil, primaryAction: action)
        let setup = showTutorial([firstTutorialItem])
        
        XCTAssertTrue(setup.page.didShowPrimaryActionButton)
    }
    
    func testItShouldNotTellTheFirstTutorialPageToShowThePrimaryActionButtonWhenPrimaryActionIsNotAvailable() {
        let firstTutorialItem = TutorialPageInfo(image: nil, title: nil, description: nil, primaryAction: nil)
        let setup = showTutorial([firstTutorialItem])
        
        XCTAssertFalse(setup.page.didShowPrimaryActionButton)
    }
    
    func testItShouldTellTheTutorialPageToShowThePrimaryActionTextWhenPrimaryActionAvailable() {
        let expectedActionDescription = "Do voodoo"
        let action = TutorialPageAction(actionDescription: expectedActionDescription, action: CapturingAction())
        let firstTutorialItem = TutorialPageInfo(image: nil, title: nil, description: nil, primaryAction: action)
        let setup = showTutorial([firstTutorialItem])
        
        XCTAssertEqual(expectedActionDescription, setup.page.capturedPrimaryActionDescription)
    }
    
    func testItShouldTellTheFirstTutorialPageToShowTheSecondaryActionButtonWhenSecondaryActionAvailable() {
        let action = TutorialPageAction(actionDescription: "", action: CapturingAction())
        let firstTutorialItem = TutorialPageInfo(image: nil, title: nil, description: nil, secondaryAction: action)
        let setup = showTutorial([firstTutorialItem])
        
        XCTAssertTrue(setup.page.didShowSecondaryActionButton)
    }
    
    func testItShouldNotTellTheFirstTutorialPageToShowTheSeondaryActionButtonWhenSecondaryActionIsNotAvailable() {
        let firstTutorialItem = TutorialPageInfo(image: nil, title: nil, description: nil, secondaryAction: nil)
        let setup = showTutorial([firstTutorialItem])
        
        XCTAssertFalse(setup.page.didShowSecondaryActionButton)
    }

    func testItShouldTellTheTutorialPageToShowTheSecondaryActionTextWhenSecondaryActionAvailable() {
        let expectedActionDescription = "Do voodoo"
        let action = TutorialPageAction(actionDescription: expectedActionDescription, action: CapturingAction())
        let firstTutorialItem = TutorialPageInfo(image: nil, title: nil, description: nil, secondaryAction: action)
        let setup = showTutorial([firstTutorialItem])
        
        XCTAssertEqual(expectedActionDescription, setup.page.capturedSecondaryActionDescription)
    }
    
    func testTappingThePrimaryActionButtonShouldInvokeThePrimaryActionForTheFirstPage() {
        let capturingAction = CapturingAction()
        let action = TutorialPageAction(actionDescription: "", action: capturingAction)
        let firstTutorialItem = TutorialPageInfo(image: nil, title: nil, description: nil, primaryAction: action)
        let setup = showTutorial([firstTutorialItem])
        setup.page.simulateTappingPrimaryActionButton()
        
        XCTAssertTrue(capturingAction.didRun)
    }
    
    func testTappingTheSecondaryActionButtonShouldInvokeTheSeoncdaryActionForTheFirstPage() {
        let capturingAction = CapturingAction()
        let action = TutorialPageAction(actionDescription: "", action: capturingAction)
        let firstTutorialItem = TutorialPageInfo(image: nil, title: nil, description: nil, secondaryAction: action)
        let setup = showTutorial([firstTutorialItem])
        setup.page.simulateTappingSecondaryActionButton()
        
        XCTAssertTrue(capturingAction.didRun)
    }

}
