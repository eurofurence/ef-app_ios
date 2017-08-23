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

class CapturingAuthService: AuthService {
    
    private let loggedInUser: User?
    
    init(loggedInUser: User? = nil) {
        self.loggedInUser = loggedInUser
    }
    
    func determineAuthState(completionHandler: @escaping (AuthState) -> Void) {
        if let user = loggedInUser {
            completionHandler(.loggedIn(user))
        }
        else {
            completionHandler(.loggedOut)
        }
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
        let authService = CapturingAuthService(loggedInUser: user)
        let newsScene = CapturingNewsScene()
        _ = NewsPresenter(authService: authService, newsScene: newsScene)
        
        XCTAssertTrue(newsScene.wasToldToShowMessagesNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsToldToShowTheLoginNavigationAction() {
        let authService = CapturingAuthService()
        let newsScene = CapturingNewsScene()
        _ = NewsPresenter(authService: authService, newsScene: newsScene)
        
        XCTAssertTrue(newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedInUserTheSceneIsNotToldToShowTheLoginNavigationAction() {
        let user = User(registrationNumber: 42, username: "")
        let authService = CapturingAuthService(loggedInUser: user)
        let newsScene = CapturingNewsScene()
        _ = NewsPresenter(authService: authService, newsScene: newsScene)
        
        XCTAssertFalse(newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testWhenLaunchedWithLoggedOutUserTheSceneIsNotToldToShowTheMessagesNavigationAction() {
        let authService = CapturingAuthService()
        let newsScene = CapturingNewsScene()
        _ = NewsPresenter(authService: authService, newsScene: newsScene)
        
        XCTAssertFalse(newsScene.wasToldToShowMessagesNavigationAction)
    }
    
}
