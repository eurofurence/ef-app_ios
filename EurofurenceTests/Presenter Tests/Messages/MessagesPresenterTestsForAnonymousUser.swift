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
    
    func testWhenSceneAppearsForTheFirstTimeTheResolveUserAuthenticationActionIsRan() {
        XCTAssertTrue(context.resolveUserAuthenticationCommand.wasRan)
    }
    
    func testWhenTheResolveUserAuthenticationActionFailsTheDelegateIsToldToDismissTheMessagesScene() {
        context.resolveUserAuthenticationCommand.failToResolveUser()
        XCTAssertTrue(context.delegate.wasToldToDismissMessagesScene)
    }
    
    func testWhenTheResolveUserAuthenticationActionSucceedsTheDelegateIsNotToldToDismissTheMessagesScene() {
        context.resolveUserAuthenticationCommand.resolveUser()
        XCTAssertFalse(context.delegate.wasToldToDismissMessagesScene)
    }
    
    func testWhenSceneAppearsTheSceneIsNotToldToShowRefreshIndicator() {
        XCTAssertFalse(context.scene.wasToldToShowRefreshIndicator)
    }
    
    func testWhenSceneAppearsThePrivateMessagesServiceIsNotToldToRefreshMessages() {
        XCTAssertFalse(context.privateMessagesService.wasToldToRefreshMessages)
    }
    
    func testWhenTheResolveUserAuthenticationActionSucceedsThePrivateMessagesServiceIsToldToRefreshMessages() {
        context.resolveUserAuthenticationCommand.resolveUser()
        XCTAssertTrue(context.privateMessagesService.wasToldToRefreshMessages)
    }
    
    func testWhenTheResolveUserAuthenticationActionSucceedsTheSceneIsToldToShowTheRefreshIndicator() {
        context.resolveUserAuthenticationCommand.resolveUser()
        XCTAssertTrue(context.scene.wasToldToShowRefreshIndicator)
    }
    
    func testWhenTheResolveUserAuthenticationActionFailsThePrivateMessagesServiceIsNotToldToRefreshMessages() {
        context.resolveUserAuthenticationCommand.failToResolveUser()
        XCTAssertFalse(context.privateMessagesService.wasToldToRefreshMessages)
    }
    
}
