//
//  MessagesPresenterTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class MessagesPresenterTests: XCTestCase {
    
    func testWhenSceneAppearsForTheFirstTimeWithLoggedOutUserTheResolveUserAuthenticationActionIsRan() {
        let context = MessagesPresenterTestContext.makeTestCaseForUnauthenticatedUser()
        XCTAssertTrue(context.resolveUserAuthenticationCommand.wasRan)
    }
    
    func testWhenSceneAppearsForTheFirstTimeWithLoggedInUserTheResolveUserAuthenticationActionIsNotRan() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertFalse(context.resolveUserAuthenticationCommand.wasRan)
    }
    
    func testWhenSceneAppearsForTheFirstTimeWithLoggedOutUserWhenTheResolveUserAuthenticationActionFailsTheMessagesPresenterDelegateIsToldToDismissTheMessagesScene() {
        let context = MessagesPresenterTestContext.makeTestCaseForUnauthenticatedUser()
        context.resolveUserAuthenticationCommand.failToResolveUser()
        
        XCTAssertTrue(context.delegate.wasToldToDismissMessagesScene)
    }
    
    func testWhenSceneAppearsForTheFirstTimeWithLoggedOutUserWhenTheResolveUserAuthenticationActionSucceedsTheMessagesPresenterDelegateIsNotToldToDismissTheMessagesScene() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.resolveUserAuthenticationCommand.resolveUser()
        
        XCTAssertFalse(context.delegate.wasToldToDismissMessagesScene)
    }
    
    func testWhenSceneAppearsWithLoggedInUserTheSceneIsToldToShowRefreshIndicator() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertTrue(context.scene.wasToldToShowRefreshIndicator)
    }
    
    func testWhenSceneAppearsWithLoggedOutUserTheSceneIsNotToldToShowRefreshIndicator() {
        let context = MessagesPresenterTestContext.makeTestCaseForUnauthenticatedUser()
        XCTAssertFalse(context.scene.wasToldToShowRefreshIndicator)
    }
    
    func testWhenSceneAppearsWithLoggedInUserThePrivateMessagesServiceIsToldToRefreshMessages() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertTrue(context.privateMessagesService.wasToldToRefreshMessages)
    }
    
    func testWhenSceneAppearsWithLoggedOutUserThePrivateMessagesServiceIsNotToldToRefreshMessages() {
        let context = MessagesPresenterTestContext.makeTestCaseForUnauthenticatedUser()
        XCTAssertFalse(context.privateMessagesService.wasToldToRefreshMessages)
    }
    
}
