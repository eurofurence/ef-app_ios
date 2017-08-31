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

protocol MessagesScene {
    
    func showRefreshIndicator()
    
}

struct MessagesPresenter {
    
    init(scene: MessagesScene,
         authService: AuthService,
         resolveUserAuthenticationAction: ResolveUserAuthenticationAction,
         delegate: MessagesPresenterDelegate) {
        authService.determineAuthState { (state) in
            switch state {
            case .loggedIn(_):
                scene.showRefreshIndicator()
                
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

class CapturingMessagesScene: MessagesScene {
    
    private(set) var wasToldToShowRefreshIndicator = false
    func showRefreshIndicator() {
        wasToldToShowRefreshIndicator = true
    }
    
}

class MessagesPresenterTests: XCTestCase {
    
    struct Context {
        
        var presenter: MessagesPresenter
        let scene = CapturingMessagesScene()
        let delegate = CapturingMessagesPresenterDelegate()
        let resolveUserAuthenticationCommand = CapturingResolveUserAuthenticationAction()
        
        static func makeTestCaseForUnauthenticatedUser() -> Context {
            return Context(authState: .loggedOut)
        }
        
        static func makeTestCaseForAuthenticatedUser(_ user: User = User(registrationNumber: 42, username: "")) -> Context {
            return Context(authState: .loggedIn(user))
        }
        
        private init(authState: AuthState) {
            presenter = MessagesPresenter(scene: scene,
                                          authService: StubAuthService(authState: authState),
                                          resolveUserAuthenticationAction: resolveUserAuthenticationCommand,
                                          delegate: delegate)
        }
        
    }
    
    func testWhenSceneAppearsForTheFirstTimeWithLoggedOutUserTheResolveUserAuthenticationActionIsRan() {
        let context = Context.makeTestCaseForUnauthenticatedUser()
        XCTAssertTrue(context.resolveUserAuthenticationCommand.wasRan)
    }
    
    func testWhenSceneAppearsForTheFirstTimeWithLoggedInUserTheResolveUserAuthenticationActionIsNotRan() {
        let context = Context.makeTestCaseForAuthenticatedUser()
        XCTAssertFalse(context.resolveUserAuthenticationCommand.wasRan)
    }
    
    func testWhenSceneAppearsForTheFirstTimeWithLoggedOutUserWhenTheResolveUserAuthenticationActionFailsTheMessagesPresenterDelegateIsToldToDismissTheMessagesScene() {
        let context = Context.makeTestCaseForUnauthenticatedUser()
        context.resolveUserAuthenticationCommand.failToResolveUser()
        
        XCTAssertTrue(context.delegate.wasToldToDismissMessagesScene)
    }
    
    func testWhenSceneAppearsForTheFirstTimeWithLoggedOutUserWhenTheResolveUserAuthenticationActionSucceedsTheMessagesPresenterDelegateIsNotToldToDismissTheMessagesScene() {
        let context = Context.makeTestCaseForAuthenticatedUser()
        context.resolveUserAuthenticationCommand.resolveUser()
        
        XCTAssertFalse(context.delegate.wasToldToDismissMessagesScene)
    }
    
    func testWhenSceneAppearsWithLoggedInUserTheSceneIsToldToShowRefreshIndicator() {
        let context = Context.makeTestCaseForAuthenticatedUser()
        XCTAssertTrue(context.scene.wasToldToShowRefreshIndicator)
    }
    
    func testWhenSceneAppearsWithLoggedOutUserTheSceneIsNotToldToShowRefreshIndicator() {
        let context = Context.makeTestCaseForUnauthenticatedUser()
        XCTAssertFalse(context.scene.wasToldToShowRefreshIndicator)
    }
    
}
