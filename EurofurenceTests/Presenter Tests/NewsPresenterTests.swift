//
//  NewsPresenterTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

enum AuthState {
    case loggedIn(User)
    case loggedOut
}

protocol AuthService {
    
    func add(observer: AuthStateObserver)
    func determineAuthState(completionHandler: @escaping (AuthState) -> Void)
    
}

protocol AuthStateObserver {
    
    func userDidLogin()
    
}

protocol NewsScene {
    
    func showMessagesNavigationAction()
    func hideMessagesNavigationAction()
    
    func showLoginNavigationAction()
    func hideLoginNavigationAction()
    
    func showWelcomePrompt(_ prompt: String)
    
}

protocol WelcomePromptStringFactory {
    
    func makeString(for user: User) -> String
    func makeStringForAnonymousUser() -> String
    
}

class StubAuthService: AuthService {
    
    private let authState: AuthState
    
    init(authState: AuthState) {
        self.authState = authState
    }
    
    private var observers = [AuthStateObserver]()
    func add(observer: AuthStateObserver) {
        observers.append(observer)
    }
    
    func determineAuthState(completionHandler: @escaping (AuthState) -> Void) {
        completionHandler(authState)
    }
    
    func notifyObserversUserDidLogin() {
        observers.forEach { $0.userDidLogin() }
    }
    
}

class CapturingNewsScene: NewsScene {
    
    private(set) var wasToldToShowMessagesNavigationAction = false
    func showMessagesNavigationAction() {
        wasToldToShowMessagesNavigationAction = true
    }
    
    private(set) var wasToldToHideMessagesNavigationAction = false
    func hideMessagesNavigationAction() {
        wasToldToHideMessagesNavigationAction = true
    }
    
    private(set) var wasToldToShowLoginNavigationAction = false
    func showLoginNavigationAction() {
        wasToldToShowLoginNavigationAction = true
    }
    
    private(set) var wasToldToHideLoginNavigationAction = false
    func hideLoginNavigationAction() {
        wasToldToHideLoginNavigationAction = true
    }
    
    private(set) var capturedWelcomePrompt: String?
    func showWelcomePrompt(_ prompt: String) {
        capturedWelcomePrompt = prompt
    }
    
}

class CapturingWelcomePromptStringFactory: WelcomePromptStringFactory {
    
    private(set) var capturedWelcomePromptUser: User?
    var stubbedUserString = ""
    func makeString(for user: User) -> String {
        capturedWelcomePromptUser = user
        return stubbedUserString
    }
    
    var stubbedLoginString = ""
    func makeStringForAnonymousUser() -> String {
        return stubbedLoginString
    }
    
}

struct DummyWelcomePromptStringFactory: WelcomePromptStringFactory {
    
    func makeString(for user: User) -> String { return "" }
    func makeStringForAnonymousUser() -> String { return "" }
    
}

struct NewsPresenter: AuthStateObserver {
    
    private let newsScene: NewsScene
    
    init(authService: AuthService, newsScene: NewsScene, welcomePromptStringFactory: WelcomePromptStringFactory) {
        self.newsScene = newsScene
        
        authService.determineAuthState() { state in
            switch state {
            case .loggedIn(let user):
                newsScene.showMessagesNavigationAction()
                newsScene.hideLoginNavigationAction()
                newsScene.showWelcomePrompt(welcomePromptStringFactory.makeString(for: user))
                
            case .loggedOut:
                newsScene.showLoginNavigationAction()
                newsScene.hideMessagesNavigationAction()
                newsScene.showWelcomePrompt(welcomePromptStringFactory.makeStringForAnonymousUser())
            }
        }
        
        authService.add(observer: self)
    }
    
    func userDidLogin() {
        newsScene.showMessagesNavigationAction()
    }
    
}

class NewsPresenterTests: XCTestCase {
    
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
    
    func testWhenLaunchedWithLoggedInUserTheSceneIsToldToShowTheMessagesNavigationAction() {
        let context = TestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertTrue(context.newsScene.wasToldToShowMessagesNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsToldToShowTheLoginNavigationAction() {
        let context = TestContext.makeTestCaseForAnonymousUser()
        XCTAssertTrue(context.newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedInUserTheSceneIsNotToldToShowTheLoginNavigationAction() {
        let context = TestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertFalse(context.newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsNotToldToShowTheMessagesNavigationAction() {
        let context = TestContext.makeTestCaseForAnonymousUser()
        XCTAssertFalse(context.newsScene.wasToldToShowMessagesNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedInUserTheSceneIsToldToHideTheLoginNavigationAction() {
        let context = TestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertTrue(context.newsScene.wasToldToHideLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsNotToldToHideTheLoginNavigationAction() {
        let context = TestContext.makeTestCaseForAnonymousUser()
        XCTAssertFalse(context.newsScene.wasToldToHideLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsToldToHideTheMessagesNavigationAction() {
        let context = TestContext.makeTestCaseForAnonymousUser()
        XCTAssertTrue(context.newsScene.wasToldToHideMessagesNavigationAction)
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
