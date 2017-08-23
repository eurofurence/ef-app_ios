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
    func showLoginNavigationAction()
    
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
    
    private(set) var wasToldToShowLoginNavigationAction = false
    func showLoginNavigationAction() {
        wasToldToShowLoginNavigationAction = true
    }
    
}

struct NewsPresenter {
    
    init(authService: AuthService, newsScene: NewsScene) {
        authService.determineAuthState() { state in
            switch state {
            case .loggedIn(_):
                newsScene.showMessagesNavigationAction()
                
            case .loggedOut:
                newsScene.showLoginNavigationAction()
            }
        }
    }
    
}

class NewsPresenterTests: XCTestCase {
    
    func testWhenLaunchedWithLoggedInUserTheSceneIsToldToShowTheMessagesNavigationAction() {
        let user = User(registrationNumber: 42, username: "")
        let authService = StubAuthService(authState: .loggedIn(user))
        let newsScene = CapturingNewsScene()
        _ = NewsPresenter(authService: authService, newsScene: newsScene)
        
        XCTAssertTrue(newsScene.wasToldToShowMessagesNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsToldToShowTheLoginNavigationAction() {
        let authService = StubAuthService(authState: .loggedOut)
        let newsScene = CapturingNewsScene()
        _ = NewsPresenter(authService: authService, newsScene: newsScene)
        
        XCTAssertTrue(newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedInUserTheSceneIsNotToldToShowTheLoginNavigationAction() {
        let user = User(registrationNumber: 42, username: "")
        let authService = StubAuthService(authState: .loggedIn(user))
        let newsScene = CapturingNewsScene()
        _ = NewsPresenter(authService: authService, newsScene: newsScene)
        
        XCTAssertFalse(newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsNotToldToShowTheMessagesNavigationAction() {
        let authService = StubAuthService(authState: .loggedOut)
        let newsScene = CapturingNewsScene()
        _ = NewsPresenter(authService: authService, newsScene: newsScene)
        
        XCTAssertFalse(newsScene.wasToldToShowMessagesNavigationAction)
    }
    
}
