//
//  MessagesPresenterTestsForLoggedInUser.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class MessagesPresenterTestsForLoggedInUser: XCTestCase {
    
    var context: MessagesPresenterTestContext!
    
    override func setUp() {
        super.setUp()
        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
    }
    
    private func makeMessageWithIdentifier(_ identifier: String) -> Message {
        return AppDataBuilder.makeMessage(identifier: identifier)
    }
    
    func testWhenSceneAppearsForTheFirstTimeTheDelegateIsNotToldToResolveUserAuthentication() {
        XCTAssertFalse(context.delegate.wasToldToResolveUser)
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
    
    func testWhenServiceHasNoLocalMessagesTheSceneIsNotToldToShowMessagesList() {
        XCTAssertFalse(context.scene.didShowMessages)
    }
    
    func testWhenServiceHasNoLocalMessagesTheSceneIsToldToHideMessages() {
        XCTAssertTrue(context.scene.didHideMessages)
    }
    
    func testWhenServiceHasNoLocalMessagesTheSceneIsToldToShowNoMessagesPlaceholder() {
        XCTAssertTrue(context.scene.didShowNoMessagesPlaceholder)
    }
    
    func testWhenServiceHasNoLocalMessagesTheSceneIsNotToldToHideTheNoMessagesPlaceholder() {
        XCTAssertFalse(context.scene.didHideNoMessagesPlaceholder)
    }
    
    func testWhenServiceHasLocalMessageTheSceneIsToldToShowMessagesList() {
        let localMessage = AppDataBuilder.makeMessage()
        context = MessagesPresenterTestContext.makeTestCaseForUserWithMessages([localMessage])
        
        XCTAssertTrue(context.scene.didShowMessages)
    }
    
    func testWhenServiceHasLocalMessageTheSceneIsToldToHideTheNoMessagesPlaceholder() {
        let localMessage = AppDataBuilder.makeMessage()
        context = MessagesPresenterTestContext.makeTestCaseForUserWithMessages([localMessage])
        
        XCTAssertTrue(context.scene.didHideNoMessagesPlaceholder)
    }
    
    func testWhenServiceHasLocalMessageTheSceneIsNotToldToHideMessages() {
        let localMessage = AppDataBuilder.makeMessage()
        context = MessagesPresenterTestContext.makeTestCaseForUserWithMessages([localMessage])
        
        XCTAssertFalse(context.scene.didHideMessages)
    }
    
    func testWhenServiceHasLocalMessageTheSceneIsNotToldToShowNoMessagesPlaceholder() {
        let localMessage = AppDataBuilder.makeMessage()
        context = MessagesPresenterTestContext.makeTestCaseForUserWithMessages([localMessage])
        
        XCTAssertFalse(context.scene.didShowNoMessagesPlaceholder)
    }
    
    func testWhenSceneSelectsMessageTheDelegateIsToldToShowTheChosenMessage() {
        let localMessage = AppDataBuilder.makeMessage()
        context = MessagesPresenterTestContext.makeTestCaseForUserWithMessages([localMessage])
        context.scene.tapMessage(at: 0)
        
        XCTAssertEqual(localMessage, context.delegate.messageToShow)
    }
    
    func testWhenSceneInstigatesRefreshActionThePrivateMessagesServiceIsToldToReload() {
        context.scene.delegate?.messagesSceneDidPerformRefreshAction()
        XCTAssertEqual(2, context.privateMessagesService.refreshMessagesCount)
    }
    
}
