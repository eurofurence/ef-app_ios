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
    
    func testTheSceneIsReturnedFromTheModuleFactory() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        XCTAssertEqual(context.newsScene, context.sceneFactory.stubbedScene)
    }
    
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
    
    func testTheNewsSceneIsToldToShowWelcomePrompt() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        XCTAssertEqual(context.newsScene.capturedLoginPrompt, .anonymousUserLoginPrompt)
    }
    
    func testTheNewsSceneIsToldToShowWelcomeDescription() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        XCTAssertEqual(context.newsScene.capturedLoginDescription, .anonymousUserLoginDescription)
    }
    
    func testTheNewsSceneIsNotToldToPresentWelcomeDesciption() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        XCTAssertNil(context.newsScene.capturedWelcomeDescription)
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
    
    func testWhenAuthServiceIndicatesUserLoggedInTheWelcomePromptShouldBeSourcedUsingTheUser() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        let user = User(registrationNumber: 42, username: "Test")
        context.authService.notifyObserversUserDidLogin(user)
        
        XCTAssertEqual(context.newsScene.capturedWelcomePrompt, .welcomePrompt(for: user))
    }
    
    func testWhenTheLoginActionIsTappedThePerformLoginCommandIsRan() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        context.newsScene.tapLoginAction()
        
        XCTAssertTrue(context.delegate.loginRequested)
    }
    
    func testThePerformLoginCommandIsNotRanUntilTheLoginActionIsTapped() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        XCTAssertFalse(context.delegate.loginRequested)
    }
    
}
