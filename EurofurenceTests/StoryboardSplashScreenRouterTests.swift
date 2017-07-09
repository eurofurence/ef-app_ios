//
//  StoryboardSplashScreenRouterTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class StoryboardSplashScreenRouterTests: XCTestCase {
    
    func testShowingTheSplashScreenShouldSetTheNavigationControllerContainingTheSplashViewControllerAsTheWindowsRootViewController() {
        let window = UIWindow(frame: .zero)
        let splashRouter = StoryboardRouters(window: window).splashScreenRouter
        _ = splashRouter.showSplashScreen()
        let navigationController = window.rootViewController as? UINavigationController

        XCTAssertTrue(navigationController?.topViewController is SplashViewController)
    }

    func testShowingTheSplashScreenShouldReturnTheSplashViewController() {
        let window = UIWindow(frame: .zero)
        let splashRouter = StoryboardRouters(window: window).splashScreenRouter
        let splashScreen = splashRouter.showSplashScreen()

        XCTAssertTrue(splashScreen is SplashViewController)
    }

}
