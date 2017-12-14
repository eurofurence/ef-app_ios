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
    
    private func makeMessageWithIdentifier(_ identifier: String) -> Message {
        return AppDataBuilder.makeMessage(identifier: identifier)
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
    
    func testFailingToLoadMessagesHidesTheRefreshIndicator() {
        context.privateMessagesService.failLastRefresh()
        XCTAssertTrue(context.scene.wasToldToHideRefreshIndicator)
    }
    
    func testSingleLocalMessageTellsSceneToShowMessagesList() {
        let localMessage = AppDataBuilder.makeMessage()
        context = MessagesPresenterTestContext.makeTestCaseForUserWithMessages([localMessage])
        context.scene.delegate?.messagesSceneWillAppear()
        
        XCTAssertTrue(context.scene.didShowMessages)
    }
    
    func testSingleLocalMessageTellsSceneToHideNoMessagesPlaceholder() {
        let localMessage = AppDataBuilder.makeMessage()
        context = MessagesPresenterTestContext.makeTestCaseForUserWithMessages([localMessage])
        context.scene.delegate?.messagesSceneWillAppear()
        
        XCTAssertTrue(context.scene.didHideNoMessagesPlaceholder)
    }
    
    func testSingleLocalMessageDoesNotTellTheSceneToHideMessages() {
        let localMessage = AppDataBuilder.makeMessage()
        context = MessagesPresenterTestContext.makeTestCaseForUserWithMessages([localMessage])
        context.scene.delegate?.messagesSceneWillAppear()
        
        XCTAssertFalse(context.scene.didHideMessages)
    }
    
    func testSingleLocalMessageDoesNotTellTheSceneToShowNoMessagesPlaceholder() {
        let localMessage = AppDataBuilder.makeMessage()
        context = MessagesPresenterTestContext.makeTestCaseForUserWithMessages([localMessage])
        context.scene.delegate?.messagesSceneWillAppear()
        
        XCTAssertFalse(context.scene.didShowNoMessagesPlaceholder)
    }
    
    func testSelectingMessageTellsTheDelegateToShowTheMessage() {
        let localMessage = AppDataBuilder.makeMessage()
        context = MessagesPresenterTestContext.makeTestCaseForUserWithMessages([localMessage])
        context.scene.delegate?.messagesSceneWillAppear()
        context.scene.tapMessage(at: 0)
        
        XCTAssertEqual(localMessage, context.delegate.messageToShow)
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
