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
    
    struct TestContext {
        
        var presenter: NewsPresenter
        var authService: StubAuthService
        let newsScene = CapturingNewsScene()
        
        @discardableResult
        static func makeTestCaseForAnonymousUser(welcomePromptStringFactory: WelcomePromptStringFactory = DummyWelcomePromptStringFactory()) -> TestContext {
            return TestContext(authService: StubAuthService(authState: .loggedOut),
                               welcomePromptStringFactory: welcomePromptStringFactory)
        }
        
        private init(authService: StubAuthService, welcomePromptStringFactory: WelcomePromptStringFactory) {
            self.authService = authService
            presenter = NewsPresenter(authService: authService,
                                      newsScene: newsScene,
                                      welcomePromptStringFactory: welcomePromptStringFactory)
        }
        
    }
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsToldToShowTheLoginNavigationAction() {
        let context = TestContext.makeTestCaseForAnonymousUser()
        XCTAssertTrue(context.newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsNotToldToShowTheMessagesNavigationAction() {
        let context = TestContext.makeTestCaseForAnonymousUser()
        XCTAssertFalse(context.newsScene.wasToldToShowMessagesNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsNotToldToHideTheLoginNavigationAction() {
        let context = TestContext.makeTestCaseForAnonymousUser()
        XCTAssertFalse(context.newsScene.wasToldToHideLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsToldToHideTheMessagesNavigationAction() {
        let context = TestContext.makeTestCaseForAnonymousUser()
        XCTAssertTrue(context.newsScene.wasToldToHideMessagesNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserShouldTellTheNewsSceneToShowWelcomePromptWithLoginHintFromStringFactory() {
        let expected = "You should totes login"
        let welcomePromptStringFactory = CapturingWelcomePromptStringFactory()
        welcomePromptStringFactory.stubbedLoginString = expected
        let context = TestContext.makeTestCaseForAnonymousUser(welcomePromptStringFactory: welcomePromptStringFactory)
        
        XCTAssertEqual(expected, context.newsScene.capturedWelcomePrompt)
    }
    
    func testWhenLaunchedWithLoggedOutUserThenAuthServiceIndicatesUserLoggedInTheSceneShouldShowTheMessagesNavigationAction() {
        let context = TestContext.makeTestCaseForAnonymousUser()
        context.authService.notifyObserversUserDidLogin()
        
        XCTAssertTrue(context.newsScene.wasToldToShowMessagesNavigationAction)
    }
    
}
