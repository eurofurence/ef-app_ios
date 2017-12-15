//
//  WhenInitialMessageLoadCompletes.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenInitialMessageLoadCompletesWithMessages: XCTestCase {
    
    var context: MessagesPresenterTestContext!
    var message: Message!
    
    override func setUp() {
        super.setUp()
        
        message = AppDataBuilder.makeMessage()
        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
        context.scene.reset()
        context.privateMessagesService.succeedLastRefresh(messages: [message])
    }
    
    func testTheRefreshIndicatorIsHidden() {        
        XCTAssertTrue(context.scene.wasToldToHideRefreshIndicator)
    }
    
    func testTheMessagesListAppears() {
        XCTAssertTrue(context.scene.didShowMessages)
    }
    
    func testTheMessagesListDoesNotDisappear() {
        XCTAssertFalse(context.scene.didHideMessages)
    }
    
    func testTheNoMessagesPlaceholderDisappear() {
        XCTAssertTrue(context.scene.didHideNoMessagesPlaceholder)
    }
    
    func testTheNoMessagesPlaceholderDoesNotAppear() {
        XCTAssertFalse(context.scene.didShowNoMessagesPlaceholder)
    }
    
}
