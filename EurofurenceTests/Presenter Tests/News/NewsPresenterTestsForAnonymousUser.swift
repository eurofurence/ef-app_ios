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
    
    // MARK: When Logging In
    
    func testWhenAuthServiceIndicatesUserLoggedInTheSceneShouldShowTheMessagesNavigationAction() {
        let context = NewsPresenterTestBuilder().build()
        context.authService.notifyObserversUserDidLogin()
        
        XCTAssertTrue(context.newsScene.wasToldToShowMessagesNavigationAction)
    }
    
    func testWhenAuthServiceIndicatesUserLoggedInTheSceneShouldHideTheLoginNavigationAction() {
        let context = NewsPresenterTestBuilder().build()
        context.authService.notifyObserversUserDidLogin()
        
        XCTAssertTrue(context.newsScene.wasToldToHideLoginNavigationAction)
    }
    
    func testWhenAuthServiceIndicatesUserLoggedInTheWelcomePromptShouldBeSourcedUsingTheUser() {
        let context = NewsPresenterTestBuilder().build()
        let user = User(registrationNumber: 42, username: "Test")
        context.authService.notifyObserversUserDidLogin(user)
        
        XCTAssertEqual(context.newsScene.capturedWelcomePrompt, .welcomePrompt(for: user))
    }
    
    // MARK: When Tapping Login Action
    
    func testWhenTheLoginActionIsTappedThePerformLoginCommandIsRan() {
        let context = NewsPresenterTestBuilder().build()
        context.newsScene.tapLoginAction()
        
        XCTAssertTrue(context.delegate.loginRequested)
    }
    
}
