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
    
    func testWhenServiceHasNoLocalMessagesTheSceneIsProvidedWithEmptyMessagesViewModel() {
        let expected = MessagesViewModel(childViewModels: [])
        XCTAssertEqual(expected, context.scene.capturedMessagesViewModel)
    }
    
    func testWhenServiceHasLocalMessageTheSceneIsToldToShowMessagesList() {
        let localMessage = AppDataBuilder.makeMessage()
        let service = CapturingPrivateMessagesService()
        service.localMessages = [localMessage]
        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        
        XCTAssertTrue(context.scene.didShowMessages)
    }
    
    func testWhenServiceHasLocalMessageTheSceneIsToldToHideTheNoMessagesPlaceholder() {
        let localMessage = AppDataBuilder.makeMessage()
        let service = CapturingPrivateMessagesService()
        service.localMessages = [localMessage]
        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        
        XCTAssertTrue(context.scene.didHideNoMessagesPlaceholder)
    }
    
    func testWhenServiceHasLocalMessageTheSceneIsNotToldToHideMessages() {
        let localMessage = AppDataBuilder.makeMessage()
        let service = CapturingPrivateMessagesService()
        service.localMessages = [localMessage]
        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        
        XCTAssertFalse(context.scene.didHideMessages)
    }
    
    func testWhenServiceHasLocalMessageTheSceneIsNotToldToShowNoMessagesPlaceholder() {
        let localMessage = AppDataBuilder.makeMessage()
        let service = CapturingPrivateMessagesService()
        service.localMessages = [localMessage]
        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        
        XCTAssertFalse(context.scene.didShowNoMessagesPlaceholder)
    }
    
    func testWhenServiceHasLocalMessageTheSceneIsProvidedWithViewModelWithMessageAuthor() {
        let localMessage = AppDataBuilder.makeMessage()
        let service = CapturingPrivateMessagesService()
        service.localMessages = [localMessage]
        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        
        XCTAssertEqual(localMessage.authorName, context.scene.capturedMessagesViewModel?.messageViewModel(at: 0).author)
    }
    
    func testWhenServiceHasLocalMessageTheSceneIsProvidedWithViewModelWithMessageSubject() {
        let localMessage = AppDataBuilder.makeMessage()
        let service = CapturingPrivateMessagesService()
        service.localMessages = [localMessage]
        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        
        XCTAssertEqual(localMessage.subject, context.scene.capturedMessagesViewModel?.messageViewModel(at: 0).subject)
    }
    
    func testWhenServiceHasLocalMessageTheSceneIsProvidedWithViewModelWithMessageContents() {
        let localMessage = AppDataBuilder.makeMessage()
        let service = CapturingPrivateMessagesService()
        service.localMessages = [localMessage]
        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        
        XCTAssertEqual(localMessage.contents, context.scene.capturedMessagesViewModel?.messageViewModel(at: 0).message)
    }
    
    func testWhenServiceHasLocalMessageTheSceneIsProvidedWithViewModelWithTheReadStatus() {
        let localMessage = AppDataBuilder.makeMessage(read: Random.makeRandomBool())
        let service = CapturingPrivateMessagesService()
        service.localMessages = [localMessage]
        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        
        XCTAssertEqual(localMessage.isRead, context.scene.capturedMessagesViewModel?.messageViewModel(at: 0).isRead)
    }
    
    func testWhenSceneTapsMessageAtIndexPathTheShowMessageActionIsInvokedWithTheExpectedMessage() {
        let expectedMessage = makeMessageWithIdentifier("B")
        let messages = [makeMessageWithIdentifier("A"), expectedMessage, makeMessageWithIdentifier("C")]
        context.privateMessagesService.succeedLastRefresh(messages: messages)
        context.scene.tapMessage(at: 1)
        
        XCTAssertEqual(expectedMessage, context.showMessageAction.capturedMessage)
    }
    
}
