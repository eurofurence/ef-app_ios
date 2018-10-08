//
//  WhenViewingMessageWhileLoggedInWithLocalMessage.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenViewingMessageWhileLoggedInWithLocalMessage: XCTestCase {
    
    var context: MessagesPresenterTestContext!
    var localMessage: Message!
    
    override func setUp() {
        super.setUp()
        
        localMessage = AppDataBuilder.makeMessage()
        context = MessagesPresenterTestContext.makeTestCaseForUserWithMessages([localMessage])
        context.scene.delegate?.messagesSceneWillAppear()
        context.privateMessagesService.succeedLastRefresh(messages: [localMessage])
    }
    
    func testTheMessagesListAppears() {
        XCTAssertTrue(context.scene.didShowMessages)
    }
    
    func testTheMessagesListIsNotHidden() {
        XCTAssertFalse(context.scene.didHideMessages)
    }
    
    func testTheNoMessagesPlaceholderIsHidden() {
        XCTAssertTrue(context.scene.didHideNoMessagesPlaceholder)
    }
    
    func testTheNoMessagesPlaceholderDoesNotAppear() {
        XCTAssertFalse(context.scene.didShowNoMessagesPlaceholder)
    }
    
    func testSelectingMessageTellsDelegateToShowTheMessage() {
        context.scene.tapMessage(at: 0)
        XCTAssertEqual(localMessage, context.delegate.messageToShow)
    }
    
}
