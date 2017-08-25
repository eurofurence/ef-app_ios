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
    
    struct TestContext {
        
        var presenter: NewsPresenter
        var authService: StubAuthService
        let newsScene = CapturingNewsScene()
        
        @discardableResult
        static func makeTestCaseForAuthenticatedUser(_ user: User = User(registrationNumber: 42, username: ""),
                                                     welcomePromptStringFactory: WelcomePromptStringFactory = DummyWelcomePromptStringFactory()) -> TestContext {
            return TestContext(authService: StubAuthService(authState: .loggedIn(user)),
                               welcomePromptStringFactory: welcomePromptStringFactory)
        }
        
        private init(authService: StubAuthService, welcomePromptStringFactory: WelcomePromptStringFactory) {
            self.authService = authService
            presenter = NewsPresenter(authService: authService,
                                      newsScene: newsScene,
                                      welcomePromptStringFactory: welcomePromptStringFactory)
        }
        
    }
    
    func testWhenLaunchedWithLoggedInUserTheSceneIsToldToShowTheMessagesNavigationAction() {
        let context = TestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertTrue(context.newsScene.wasToldToShowMessagesNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedInUserTheSceneIsNotToldToShowTheLoginNavigationAction() {
        let context = TestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertFalse(context.newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedInUserTheSceneIsToldToHideTheLoginNavigationAction() {
        let context = TestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertTrue(context.newsScene.wasToldToHideLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedInUserTheSceneIsNotToldToHideTheMessagesNavigationAction() {
        let context = TestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertFalse(context.newsScene.wasToldToHideMessagesNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedInUserTheWelcomePromptShouldBeSourcedFromTheWelcomePromptStringFactoryUsingTheUser() {
        let user = User(registrationNumber: 42, username: "Cool dude")
        let welcomePromptStringFactory = CapturingWelcomePromptStringFactory()
        TestContext.makeTestCaseForAuthenticatedUser(user, welcomePromptStringFactory: welcomePromptStringFactory)
        
        XCTAssertEqual(user, welcomePromptStringFactory.capturedWelcomePromptUser)
    }
    
    func testWhenLaunchedWithLoggedInUserTheWelcomePromptShouldBeSourcedFromTheWelcomePromptStringFactory() {
        let expected = "Welcome to the world of tomorrow"
        let welcomePromptStringFactory = CapturingWelcomePromptStringFactory()
        welcomePromptStringFactory.stubbedUserString = expected
        let context = TestContext.makeTestCaseForAuthenticatedUser(welcomePromptStringFactory: welcomePromptStringFactory)
        
        XCTAssertEqual(expected, context.newsScene.capturedWelcomePrompt)
    }
    
}
