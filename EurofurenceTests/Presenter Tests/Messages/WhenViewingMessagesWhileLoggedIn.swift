//
//  MessagesPresenterTestsForLoggedInUser.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenViewingMessagesAndLoggedIn: XCTestCase {
    
    var context: MessagesPresenterTestContext!
    
    override func setUp() {
        super.setUp()
        
        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
    }
    
    func testTheDelegateIsNotToldToResolveUserAuthentication() {
        XCTAssertFalse(context.delegate.wasToldToResolveUser)
    }
    
    func testTheSceneIsToldToShowRefreshIndicator() {
        XCTAssertTrue(context.scene.wasToldToShowRefreshIndicator)
    }
    
    func testTheSceneIsNotToldToHideRefreshIndicator() {
        XCTAssertFalse(context.scene.wasToldToHideRefreshIndicator)
    }
    
    func testThePrivateMessagesServiceIsToldToRefreshMessages() {
        XCTAssertTrue(context.privateMessagesService.wasToldToRefreshMessages)
    }
    
    func testWhenSceneInstigatesRefreshActionThePrivateMessagesServiceIsToldToReload() {
        context.scene.delegate?.messagesSceneDidPerformRefreshAction()
        XCTAssertEqual(2, context.privateMessagesService.refreshMessagesCount)
    }
    
    func testWhenInstigatedRefreshThatFinishesTheSceneIsToldToHideTheRefreshIndicator() {
        context.scene.delegate?.messagesSceneDidPerformRefreshAction()
        context.privateMessagesService.succeedLastRefresh()
        
        XCTAssertTrue(context.scene.wasToldToHideRefreshIndicator)
    }
    
}
