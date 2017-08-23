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
    
}

class CapturingAuthService: AuthService {
    
    private let loggedInUser: User?
    
    init(loggedInUser: User? = nil) {
        self.loggedInUser = loggedInUser
    }
    
    private(set) var wasRequestedToDetermineAuthState = false
    func determineAuthState(completionHandler: @escaping (AuthState) -> Void) {
        wasRequestedToDetermineAuthState = true
        
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
    
}

struct NewsPresenter {
    
    init(authService: AuthService, newsScene: NewsScene) {
        authService.determineAuthState() { _ in }
        newsScene.showMessagesNavigationAction()
    }
    
}

class NewsPresenterTests: XCTestCase {
    
    func testWhenLaunchedTheAuthServiceIsRequestedTheLoginState() {
        let authService = CapturingAuthService()
        _ = NewsPresenter(authService: authService, newsScene: CapturingNewsScene())
        
        XCTAssertTrue(authService.wasRequestedToDetermineAuthState)
    }
    
    func testWhenLaunchedWithLoggedInUserTheSceneIsToldToShowTheMessagesNavigationAction() {
        let user = User(registrationNumber: 42, username: "")
        let authService = CapturingAuthService(loggedInUser: user)
        let newsScene = CapturingNewsScene()
        _ = NewsPresenter(authService: authService, newsScene: newsScene)
        
        XCTAssertTrue(newsScene.wasToldToShowMessagesNavigationAction)
    }
    
}
