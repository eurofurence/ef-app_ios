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
        context.scene.reset()
        context.privateMessagesService.succeedLastRefresh()
        
        XCTAssertTrue(context.scene.wasToldToHideRefreshIndicator)
    }
    
    func testWhenRefreshActionCompletesWithNoMessagesTheSceneIsToldToHideTheMessagesList() {
        context.scene.delegate?.messagesSceneDidPerformRefreshAction()
        context.scene.reset()
        context.privateMessagesService.succeedLastRefresh()
        
        XCTAssertTrue(context.scene.didHideMessages)
    }
    
    func testWhenRefreshActionCompletesWithNoMessagesTheSceneIsNotToldToShowTheMessagesList() {
        context.scene.delegate?.messagesSceneDidPerformRefreshAction()
        context.scene.reset()
        context.privateMessagesService.succeedLastRefresh()
        
        XCTAssertFalse(context.scene.didShowMessages)
    }
    
    func testWhenRefreshActionCompletesWithMessagesTheSceneIsToldToShowTheMessagesList() {
        context.scene.delegate?.messagesSceneDidPerformRefreshAction()
        context.scene.reset()
        context.privateMessagesService.succeedLastRefresh(messages: [AppDataBuilder.makeMessage()])
        
        XCTAssertTrue(context.scene.didShowMessages)
    }
    
    func testWhenRefreshActionCompletesWithNoMessagesTheSceneIsToldShowTheNoMessagesPlaceholder() {
        context.scene.delegate?.messagesSceneDidPerformRefreshAction()
        context.scene.reset()
        context.privateMessagesService.succeedLastRefresh()
        
        XCTAssertTrue(context.scene.didShowNoMessagesPlaceholder)
    }
    
    func testWhenRefreshActionCompletesWithMessagesTheSceneIsNotToldShowTheNoMessagesPlaceholder() {
        context.scene.delegate?.messagesSceneDidPerformRefreshAction()
        context.scene.reset()
        context.privateMessagesService.succeedLastRefresh(messages: [AppDataBuilder.makeMessage()])
        
        XCTAssertFalse(context.scene.didShowNoMessagesPlaceholder)
    }
    
    func testWhenRefreshActionCompletesWithMessageTheSceneIsToldHideTheNoMessagesPlaceholder() {
        context.scene.delegate?.messagesSceneDidPerformRefreshAction()
        context.scene.reset()
        context.privateMessagesService.succeedLastRefresh(messages: [AppDataBuilder.makeMessage()])
        
        XCTAssertTrue(context.scene.didHideNoMessagesPlaceholder)
    }
    
    func testWhenRefreshActionCompletesWithNoMessagesTheSceneIsNotToldHideTheNoMessagesPlaceholder() {
        context.scene.delegate?.messagesSceneDidPerformRefreshAction()
        context.scene.reset()
        context.privateMessagesService.succeedLastRefresh()
        
        XCTAssertFalse(context.scene.didHideNoMessagesPlaceholder)
    }
    
}
