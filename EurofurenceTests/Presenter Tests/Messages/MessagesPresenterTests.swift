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
    
    func run(completionHandler: @escaping (Bool) -> Void)
    
}

protocol MessagesPresenterDelegate {
    
    func dismissMessagesScene()
    
}

struct MessagesPresenter {
    
    init(authService: AuthService,
         resolveUserAuthenticationAction: ResolveUserAuthenticationAction,
         delegate: MessagesPresenterDelegate) {
        authService.determineAuthState { (state) in
            switch state {
            case .loggedIn(_):
                break
                
            case .loggedOut:
                resolveUserAuthenticationAction.run { resolvedUser in
                    if !resolvedUser {
                        delegate.dismissMessagesScene()
                    }
                }
            }
        }
    }
    
}

class CapturingResolveUserAuthenticationAction: ResolveUserAuthenticationAction {
    
    private(set) var wasRan = false
    private var completionHandler: ((Bool) -> Void)?
    func run(completionHandler: @escaping (Bool) -> Void) {
        wasRan = true
        self.completionHandler = completionHandler
    }
    
    func resolveUser() {
        completionHandler?(true)
    }
    
    func failToResolveUser() {
        completionHandler?(false)
    }
    
}

struct DummyMessagesPresenterDelegate: MessagesPresenterDelegate {
    
    func dismissMessagesScene() { }
    
}

class CapturingMessagesPresenterDelegate: MessagesPresenterDelegate {
    
    private(set) var wasToldToDismissMessagesScene = false
    func dismissMessagesScene() {
        wasToldToDismissMessagesScene = true
    }
    
}

class MessagesPresenterTests: XCTestCase {
    
    func testWhenSceneAppearsForTheFirstTimeWithLoggedOutUserTheResolveUserAuthenticationActionIsRan() {
        let resolveUserAuthenticationCommand = CapturingResolveUserAuthenticationAction()
        let authService = StubAuthService(authState: .loggedOut)
        _ = MessagesPresenter(authService: authService,
                              resolveUserAuthenticationAction: resolveUserAuthenticationCommand,
                              delegate: DummyMessagesPresenterDelegate())
        
        XCTAssertTrue(resolveUserAuthenticationCommand.wasRan)
    }
    
    func testWhenSceneAppearsForTheFirstTimeWithLoggedInUserTheResolveUserAuthenticationActionIsNotRan() {
        let resolveUserAuthenticationCommand = CapturingResolveUserAuthenticationAction()
        let authService = StubAuthService(authState: .loggedIn(User(registrationNumber: 42, username: "")))
        _ = MessagesPresenter(authService: authService,
                              resolveUserAuthenticationAction: resolveUserAuthenticationCommand,
                              delegate: DummyMessagesPresenterDelegate())
        
        XCTAssertFalse(resolveUserAuthenticationCommand.wasRan)
    }
    
    func testWhenSceneAppearsForTheFirstTimeWithLoggedOutUserWhenTheResolveUserAuthenticationActionFailsTheMessagesPresenterDelegateIsToldToDismissTheMessagesScene() {
        let resolveUserAuthenticationCommand = CapturingResolveUserAuthenticationAction()
        let messagesPresenterDelegate = CapturingMessagesPresenterDelegate()
        let authService = StubAuthService(authState: .loggedOut)
        _ = MessagesPresenter(authService: authService,
                              resolveUserAuthenticationAction: resolveUserAuthenticationCommand,
                              delegate: messagesPresenterDelegate)
        resolveUserAuthenticationCommand.failToResolveUser()
        
        XCTAssertTrue(messagesPresenterDelegate.wasToldToDismissMessagesScene)
    }
    
    func testWhenSceneAppearsForTheFirstTimeWithLoggedOutUserWhenTheResolveUserAuthenticationActionSucceedsTheMessagesPresenterDelegateIsNotToldToDismissTheMessagesScene() {
        let resolveUserAuthenticationCommand = CapturingResolveUserAuthenticationAction()
        let messagesPresenterDelegate = CapturingMessagesPresenterDelegate()
        let authService = StubAuthService(authState: .loggedOut)
        _ = MessagesPresenter(authService: authService,
                              resolveUserAuthenticationAction: resolveUserAuthenticationCommand,
                              delegate: messagesPresenterDelegate)
        resolveUserAuthenticationCommand.resolveUser()
        
        XCTAssertFalse(messagesPresenterDelegate.wasToldToDismissMessagesScene)
    }
    
}
