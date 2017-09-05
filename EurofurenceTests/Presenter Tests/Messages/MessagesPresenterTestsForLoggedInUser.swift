//
//  MessagesPresenterTestsForLoggedInUser.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import XCTest

class MessagesPresenterTestsForLoggedInUser: XCTestCase {
    
    var context: MessagesPresenterTestContext!
    
    override func setUp() {
        super.setUp()
        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
    }
    
    func testWhenSceneAppearsForTheFirstTimeTheResolveUserAuthenticationActionIsNotRan() {
        XCTAssertFalse(context.resolveUserAuthenticationCommand.wasRan)
    }
    
    func testWhenSceneAppearsTheSceneIsToldToShowRefreshIndicator() {
        XCTAssertTrue(context.scene.wasToldToShowRefreshIndicator)
    }
    
    func testWhenSceneAppearsTheSceneIsNotToldToHideRefreshIndicator() {
        XCTAssertFalse(context.scene.wasToldToHideRefreshIndicator)
    }
    
    func testWhenSceneAppearsThePrivateMessagesServiceIsToldToRefreshMessages() {
        XCTAssertTrue(context.privateMessagesService.wasToldToRefreshMessages)
    }
    
    func testWhenPrivateMessagesServiceFailsToLoadMessagesTheSceneIsToldToHideTheRefreshIndicator() {
        context.privateMessagesService.failLastRefresh()
        XCTAssertTrue(context.scene.wasToldToHideRefreshIndicator)
    }
    
    func testWhenPrivateMessagesServiceSucceedsLoadingMessagesTheSceneIsToldToHideTheRefreshIndicator() {
        context.privateMessagesService.succeedLastRefresh()
        XCTAssertTrue(context.scene.wasToldToHideRefreshIndicator)
    }
    
}
