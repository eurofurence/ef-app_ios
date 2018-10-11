//
//  StoryboardTutorialRouterTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest
import UIKit

class StoryboardTutorialRouterTests: XCTestCase {

    func testShowingTheTutorialShouldSetTheTutorialViewControllerAsTheWindowsRootViewController() {
        let window = UIWindow(frame: .zero)
        let tutorialRouter = StoryboardRouters(window: window).tutorialRouter
        _ = tutorialRouter.showTutorial()

        XCTAssertTrue(window.rootViewController is TutorialViewController)
    }

    func testShowingTheTutorialShouldUseTheTutorialViewControllerFromTheStoryboard() {
        let window = UIWindow(frame: .zero)
        let tutorialRouter = StoryboardRouters(window: window).tutorialRouter
        _ = tutorialRouter.showTutorial()

        XCTAssertNotNil(window.rootViewController?.storyboard)
    }

    func testShowingTheTutorialShouldReturnTheTutorialViewControllerSetOntoTheWindow() {
        let window = UIWindow(frame: .zero)
        let tutorialRouter = StoryboardRouters(window: window).tutorialRouter
        let tutorialScene = tutorialRouter.showTutorial()

        XCTAssertTrue((tutorialScene as? UIViewController) === window.rootViewController)
    }

}
