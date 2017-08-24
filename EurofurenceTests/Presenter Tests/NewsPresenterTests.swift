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
    
    func determineAuthState(completionHandler: @escaping (AuthState) -> Void)
    
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
    
}

struct StubAuthService: AuthService {
    
    var authState: AuthState
    
    func determineAuthState(completionHandler: @escaping (AuthState) -> Void) {
        completionHandler(authState)
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
    
}

struct DummyWelcomePromptStringFactory: WelcomePromptStringFactory {
    
    func makeString(for user: User) -> String { return "" }
    
}

struct NewsPresenter {
    
    init(authService: AuthService, newsScene: NewsScene, welcomePromptStringFactory: WelcomePromptStringFactory) {
        authService.determineAuthState() { state in
            switch state {
            case .loggedIn(let user):
                newsScene.showMessagesNavigationAction()
                newsScene.hideLoginNavigationAction()
                newsScene.showWelcomePrompt(welcomePromptStringFactory.makeString(for: user))
                
            case .loggedOut:
                newsScene.showLoginNavigationAction()
                newsScene.hideMessagesNavigationAction()
                newsScene.showWelcomePrompt("You are currently not logged in")
            }
        }
    }
    
}

class NewsPresenterTests: XCTestCase {
    
    func testWhenLaunchedWithLoggedInUserTheSceneIsToldToShowTheMessagesNavigationAction() {
        let user = User(registrationNumber: 42, username: "")
        let authService = StubAuthService(authState: .loggedIn(user))
        let newsScene = CapturingNewsScene()
        _ = NewsPresenter(authService: authService, newsScene: newsScene, welcomePromptStringFactory: DummyWelcomePromptStringFactory())
        
        XCTAssertTrue(newsScene.wasToldToShowMessagesNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsToldToShowTheLoginNavigationAction() {
        let authService = StubAuthService(authState: .loggedOut)
        let newsScene = CapturingNewsScene()
        _ = NewsPresenter(authService: authService, newsScene: newsScene, welcomePromptStringFactory: DummyWelcomePromptStringFactory())
        
        XCTAssertTrue(newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedInUserTheSceneIsNotToldToShowTheLoginNavigationAction() {
        let user = User(registrationNumber: 42, username: "")
        let authService = StubAuthService(authState: .loggedIn(user))
        let newsScene = CapturingNewsScene()
        _ = NewsPresenter(authService: authService, newsScene: newsScene, welcomePromptStringFactory: DummyWelcomePromptStringFactory())
        
        XCTAssertFalse(newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsNotToldToShowTheMessagesNavigationAction() {
        let authService = StubAuthService(authState: .loggedOut)
        let newsScene = CapturingNewsScene()
        _ = NewsPresenter(authService: authService, newsScene: newsScene, welcomePromptStringFactory: DummyWelcomePromptStringFactory())
        
        XCTAssertFalse(newsScene.wasToldToShowMessagesNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedInUserTheSceneIsToldToHideTheLoginNavigationAction() {
        let user = User(registrationNumber: 42, username: "")
        let authService = StubAuthService(authState: .loggedIn(user))
        let newsScene = CapturingNewsScene()
        _ = NewsPresenter(authService: authService, newsScene: newsScene, welcomePromptStringFactory: DummyWelcomePromptStringFactory())
        
        XCTAssertTrue(newsScene.wasToldToHideLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsNotToldToHideTheLoginNavigationAction() {
        let authService = StubAuthService(authState: .loggedOut)
        let newsScene = CapturingNewsScene()
        _ = NewsPresenter(authService: authService, newsScene: newsScene, welcomePromptStringFactory: DummyWelcomePromptStringFactory())
        
        XCTAssertFalse(newsScene.wasToldToHideLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsToldToHideTheMessagesNavigationAction() {
        let authService = StubAuthService(authState: .loggedOut)
        let newsScene = CapturingNewsScene()
        _ = NewsPresenter(authService: authService, newsScene: newsScene, welcomePromptStringFactory: DummyWelcomePromptStringFactory())
        
        XCTAssertTrue(newsScene.wasToldToHideMessagesNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedInUserTheSceneIsNotToldToHideTheMessagesNavigationAction() {
        let user = User(registrationNumber: 42, username: "")
        let authService = StubAuthService(authState: .loggedIn(user))
        let newsScene = CapturingNewsScene()
        _ = NewsPresenter(authService: authService, newsScene: newsScene, welcomePromptStringFactory: DummyWelcomePromptStringFactory())
        
        XCTAssertFalse(newsScene.wasToldToHideMessagesNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedInUserTheWelcomePromptShouldBeSourcedFromTheWelcomePromptStringFactoryUsingTheUser() {
        let user = User(registrationNumber: 42, username: "Cool dude")
        let authService = StubAuthService(authState: .loggedIn(user))
        let newsScene = CapturingNewsScene()
        let welcomePromptStringFactory = CapturingWelcomePromptStringFactory()
        _ = NewsPresenter(authService: authService, newsScene: newsScene, welcomePromptStringFactory: welcomePromptStringFactory)
        
        XCTAssertEqual(user, welcomePromptStringFactory.capturedWelcomePromptUser)
    }
    
    func testWhenLaunchedWithLoggedInUserTheWelcomePromptShouldBeSourcedFromTheWelcomePromptStringFactory() {
        let expected = "Welcome to the world of tomorrow"
        let user = User(registrationNumber: 42, username: "Cool dude")
        let authService = StubAuthService(authState: .loggedIn(user))
        let newsScene = CapturingNewsScene()
        let welcomePromptStringFactory = CapturingWelcomePromptStringFactory()
        welcomePromptStringFactory.stubbedUserString = expected
        _ = NewsPresenter(authService: authService, newsScene: newsScene, welcomePromptStringFactory: welcomePromptStringFactory)
        
        XCTAssertEqual(expected, newsScene.capturedWelcomePrompt)
    }
    
    func testWhenLaunchedWithLoggedOutUserShouldTellTheNewsSceneToShowWelcomePromptWithLoginHint() {
        let authService = StubAuthService(authState: .loggedOut)
        let newsScene = CapturingNewsScene()
        _ = NewsPresenter(authService: authService, newsScene: newsScene, welcomePromptStringFactory: DummyWelcomePromptStringFactory())
        
        XCTAssertEqual("You are currently not logged in", newsScene.capturedWelcomePrompt)
    }
    
}
