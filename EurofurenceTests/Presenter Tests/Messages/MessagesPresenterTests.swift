//
//  MessagesPresenterTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

protocol ResolveUserAuthenticationAction {
    
    func run()
    
}

struct MessagesPresenter {
    
    init(authService: AuthService, resolveUserAuthenticationAction: ResolveUserAuthenticationAction) {
        authService.determineAuthState { (state) in
            switch state {
            case .loggedIn(_):
                break
                
            case .loggedOut:
                resolveUserAuthenticationAction.run()
            }
        }
    }
    
}

class CapturingResolveUserAuthenticationAction: ResolveUserAuthenticationAction {
    
    private(set) var wasRan = false
    func run() {
        wasRan = true
    }
    
}

class MessagesPresenterTests: XCTestCase {
    
    func testWhenSceneAppearsForTheFirstTimeWithLoggedOutUserTheResolveUserAuthenticationActionIsRan() {
        let resolveUserAuthenticationCommand = CapturingResolveUserAuthenticationAction()
        let authService = StubAuthService(authState: .loggedOut)
        _ = MessagesPresenter(authService: authService, resolveUserAuthenticationAction: resolveUserAuthenticationCommand)
        
        XCTAssertTrue(resolveUserAuthenticationCommand.wasRan)
    }
    
    func testWhenSceneAppearsForTheFirstTimeWithLoggedInUserTheResolveUserAuthenticationActionIsNotRan() {
        let resolveUserAuthenticationCommand = CapturingResolveUserAuthenticationAction()
        let authService = StubAuthService(authState: .loggedIn(User(registrationNumber: 42, username: "")))
        _ = MessagesPresenter(authService: authService, resolveUserAuthenticationAction: resolveUserAuthenticationCommand)
        
        XCTAssertFalse(resolveUserAuthenticationCommand.wasRan)
    }
    
}
