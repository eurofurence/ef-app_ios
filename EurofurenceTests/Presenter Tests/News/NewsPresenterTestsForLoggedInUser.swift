//
//  NewsPresenterTestsForLoggedInUser.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class NewsPresenterTestsForLoggedInUser: XCTestCase {
    
    func testWhenLaunchedWithLoggedInUserTheSceneIsToldToShowTheMessagesNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertTrue(context.newsScene.wasToldToShowMessagesNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedInUserTheSceneIsNotToldToShowTheLoginNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertFalse(context.newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedInUserTheSceneIsToldToHideTheLoginNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertTrue(context.newsScene.wasToldToHideLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedInUserTheSceneIsNotToldToHideTheMessagesNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertFalse(context.newsScene.wasToldToHideMessagesNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedInUserTheWelcomePromptShouldBeSourcedFromTheWelcomePromptStringFactoryUsingTheUser() {
        let user = User(registrationNumber: 42, username: "Cool dude")
        let welcomePromptStringFactory = CapturingWelcomePromptStringFactory()
        NewsPresenterTestContext.makeTestCaseForAuthenticatedUser(user, welcomePromptStringFactory: welcomePromptStringFactory)
        
        XCTAssertEqual(user, welcomePromptStringFactory.capturedWelcomePromptUser)
    }
    
    func testWhenLaunchedWithLoggedInUserTheWelcomePromptShouldBeSourcedFromTheWelcomePromptStringFactory() {
        let expected = "Welcome to the world of tomorrow"
        let welcomePromptStringFactory = CapturingWelcomePromptStringFactory()
        welcomePromptStringFactory.stubbedUserString = expected
        let context = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser(welcomePromptStringFactory: welcomePromptStringFactory)
        
        XCTAssertEqual(expected, context.newsScene.capturedWelcomePrompt)
    }
    
}
