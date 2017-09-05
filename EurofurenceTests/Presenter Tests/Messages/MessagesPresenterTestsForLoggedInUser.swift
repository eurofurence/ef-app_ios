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
    
    func testWhenServiceHasNoLocalMessagesTheSceneIsProvidedWithEmptyMessagesViewModel() {
        let expected = MessagesViewModel()
        XCTAssertEqual(expected, context.scene.capturedMessagesViewModel)
    }
    
    func testWhenServiceHasLocalMessageTheSceneIsProvidedWithViewModelWithMessage() {
        let localMessage = AppDataBuilder.makeMessage()
        let service = CapturingPrivateMessagesService()
        service.localMessages = [localMessage]
        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        let expected = MessagesViewModel(messages: [localMessage])
        
        XCTAssertEqual(expected, context.scene.capturedMessagesViewModel)
    }
    
    func testWhenServiceSucceedsLoadingMessagesTheSceneIsProvidedWithViewModelForMessages() {
        let makeMessage: (String) -> Message = { AppDataBuilder.makeMessage(identifier: $0) }
        let messages = [makeMessage("A"), makeMessage("A"), makeMessage("A")]
        let expected = MessagesViewModel(messages: messages)
        context.privateMessagesService.succeedLastRefresh(messages: messages)
        
        XCTAssertEqual(expected, context.scene.capturedMessagesViewModel)
    }
    
}
