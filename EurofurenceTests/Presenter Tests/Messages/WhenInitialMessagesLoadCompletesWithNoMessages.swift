//
//  WhenInitialMessagesLoadCompletes.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenInitialMessagesLoadCompletesWithNoMessages: XCTestCase {
    
    var context: MessagesPresenterTestContext!
    
    override func setUp() {
        super.setUp()
        
        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
        context.privateMessagesService.succeedLastRefresh()
    }
    
    func testTheRefreshIndicatorIsHidden() {
        XCTAssertTrue(context.scene.wasToldToHideRefreshIndicator)
    }
    
    func testTheMessagesListAppears() {
        XCTAssertTrue(context.scene.didHideMessages)
    }
    
    func testTheMessagesListDoesNotHide() {
        XCTAssertFalse(context.scene.didShowMessages)
    }
    
    func testTheNoMessagesPlaceholderAppears() {
        XCTAssertTrue(context.scene.didShowNoMessagesPlaceholder)
    }
    
    func testTheNoMessagesPlaceholderIsNotHidden() {
        XCTAssertFalse(context.scene.didHideNoMessagesPlaceholder)
    }
    
}
