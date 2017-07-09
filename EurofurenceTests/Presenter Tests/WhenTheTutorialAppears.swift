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
        _ = BootstrappingPresenter(context: context, routers: routers)

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

}
