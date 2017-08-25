//
//  NewsPresenterTestsForAnonymousUser.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class NewsPresenterTestsForAnonymousUser: XCTestCase {
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsToldToShowTheLoginNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        XCTAssertTrue(context.newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsNotToldToShowTheMessagesNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        XCTAssertFalse(context.newsScene.wasToldToShowMessagesNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsNotToldToHideTheLoginNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        XCTAssertFalse(context.newsScene.wasToldToHideLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsToldToHideTheMessagesNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        XCTAssertTrue(context.newsScene.wasToldToHideMessagesNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserShouldTellTheNewsSceneToShowWelcomePromptWithLoginHintFromStringFactory() {
        let expected = "You should totes login"
        let welcomePromptStringFactory = CapturingWelcomePromptStringFactory()
        welcomePromptStringFactory.stubbedLoginString = expected
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser(welcomePromptStringFactory: welcomePromptStringFactory)
        
        XCTAssertEqual(expected, context.newsScene.capturedWelcomePrompt)
    }
    
    func testWhenLaunchedWithLoggedOutUserThenAuthServiceIndicatesUserLoggedInTheSceneShouldShowTheMessagesNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        context.authService.notifyObserversUserDidLogin()
        
        XCTAssertTrue(context.newsScene.wasToldToShowMessagesNavigationAction)
    }
    
}
