//
//  MessagesPresenterTestsForAnonymousUser.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class MessagesPresenterTestsForAnonymousUser: XCTestCase {
    
    var context: MessagesPresenterTestContext!
    
    override func setUp() {
        super.setUp()
        context = MessagesPresenterTestContext.makeTestCaseForUnauthenticatedUser()
    }
    
    func testWhenSceneAppearsForTheFirstTimeTheDelegateIsToldToResolveUserAuthentication() {
        XCTAssertTrue(context.delegate.wasToldToResolveUser)
    }
    
    func testTheAuthServiceDoesNotDetermineAuthStateUntilTheSceneWillAppear() {
        let authenticationService = CapturingAuthenticationService()
        _ = MessagesModuleBuilder()
            .with(StubMessagesSceneFactory())
            .with(authenticationService)
            .build()
            .makeMessagesModule(CapturingMessagesModuleDelegate())
        
        XCTAssertEqual(0, authenticationService.authStateDeterminedCount)
    }
    
    func testWhenTheDelegateCannotResolveUserAuthenticationTheDelegateIsToldToDismissTheMessagesScene() {
        context.delegate.failToResolveUser()
        XCTAssertTrue(context.delegate.dismissed)
    }
    
    func testWhenTheDelegateResolvesUserAuthenticationActionTheDelegateIsNotToldToDismissTheMessagesScene() {
        context.delegate.resolveUser()
        XCTAssertFalse(context.delegate.dismissed)
    }
    
    func testWhenSceneAppearsTheSceneIsNotToldToShowRefreshIndicator() {
        XCTAssertFalse(context.scene.wasToldToShowRefreshIndicator)
    }
    
    func testWhenSceneAppearsThePrivateMessagesServiceIsNotToldToRefreshMessages() {
        XCTAssertFalse(context.privateMessagesService.wasToldToRefreshMessages)
    }
    
    func testWhenTheDelegateResolvesUserAuthenticationThePrivateMessagesServiceIsToldToRefreshMessages() {
        context.delegate.resolveUser()
        XCTAssertTrue(context.privateMessagesService.wasToldToRefreshMessages)
    }
    
    func testWhenTheDelegateResolvesUserAuthenticationTheSceneIsToldToShowTheRefreshIndicator() {
        context.delegate.resolveUser()
        XCTAssertTrue(context.scene.wasToldToShowRefreshIndicator)
    }
    
    func testWhenTheDelegateDoesNotResolveUserAuthenticationThePrivateMessagesServiceIsNotToldToRefreshMessages() {
        context.delegate.failToResolveUser()
        XCTAssertFalse(context.privateMessagesService.wasToldToRefreshMessages)
    }
    
}
