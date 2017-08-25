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
    
    func testTheSceneIsToldToShowTheLoginNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        XCTAssertTrue(context.newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testTheSceneIsNotToldToShowTheMessagesNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        XCTAssertFalse(context.newsScene.wasToldToShowMessagesNavigationAction)
    }
    
    func testTheSceneIsNotToldToHideTheLoginNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        XCTAssertFalse(context.newsScene.wasToldToHideLoginNavigationAction)
    }
    
    func testTheSceneIsToldToHideTheMessagesNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        XCTAssertTrue(context.newsScene.wasToldToHideMessagesNavigationAction)
    }
    
    func testTheNewsSceneIsToldToShowWelcomePromptWithLoginHintFromStringFactory() {
        let expected = "You should totes login"
        let welcomePromptStringFactory = CapturingWelcomePromptStringFactory()
        welcomePromptStringFactory.stubbedLoginString = expected
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser(welcomePromptStringFactory: welcomePromptStringFactory)
        
        XCTAssertEqual(expected, context.newsScene.capturedWelcomePrompt)
    }
    
    func testWhenAuthServiceIndicatesUserLoggedInTheSceneShouldShowTheMessagesNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        context.authService.notifyObserversUserDidLogin()
        
        XCTAssertTrue(context.newsScene.wasToldToShowMessagesNavigationAction)
    }
    
    func testWhenAuthServiceIndicatesUserLoggedInTheSceneShouldHideTheLoginNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        context.authService.notifyObserversUserDidLogin()
        
        XCTAssertTrue(context.newsScene.wasToldToHideLoginNavigationAction)
    }
    
    func testWhenAuthServiceIndicatesUserLoggedInTheWelcomePromptStringFactoryShouldUseTheLoggedInUserToGeneratePrompt() {
        let welcomePromptStringFactory = CapturingWelcomePromptStringFactory()
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser(welcomePromptStringFactory: welcomePromptStringFactory)
        let user = User(registrationNumber: 42, username: "")
        context.authService.notifyObserversUserDidLogin(user)
        
        XCTAssertEqual(user, welcomePromptStringFactory.capturedWelcomePromptUser)
    }
    
    func testWhenAuthServiceIndicatesUserLoggedInTheWelcomePromptShouldBeSourcedFromTheStringFactory() {
        let expected = "Welcome to the world of tomorrow"
        let welcomePromptStringFactory = CapturingWelcomePromptStringFactory()
        welcomePromptStringFactory.stubbedUserString = expected
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser(welcomePromptStringFactory: welcomePromptStringFactory)
        context.authService.notifyObserversUserDidLogin()
        
        XCTAssertEqual(expected, context.newsScene.capturedWelcomePrompt)
    }
    
}
