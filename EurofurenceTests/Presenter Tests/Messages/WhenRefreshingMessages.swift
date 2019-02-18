//
//  WhenRefreshingMessages.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenRefreshingMessages: XCTestCase {

    var context: MessagesPresenterTestContext!

    override func setUp() {
        super.setUp()

        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
        context.scene.delegate?.messagesSceneDidPerformRefreshAction()
        context.scene.reset()
    }

    func testThePrivateMessagesServiceIsToldToReload() {
        XCTAssertEqual(2, context.privateMessagesService.refreshMessagesCount)
    }

    func testTheSceneIsToldToHideTheRefreshIndicatorWhenRefreshFinishes() {
        context.privateMessagesService.succeedLastRefresh()
        XCTAssertTrue(context.scene.wasToldToHideRefreshIndicator)
    }

    func testWhenRefreshActionCompletesWithNoMessagesTheSceneIsToldToHideTheMessagesList() {
        context.privateMessagesService.succeedLastRefresh()
        XCTAssertTrue(context.scene.didHideMessages)
    }

    func testWhenRefreshActionCompletesWithNoMessagesTheSceneIsNotToldToShowTheMessagesList() {
        context.privateMessagesService.succeedLastRefresh()
        XCTAssertFalse(context.scene.didShowMessages)
    }

    func testWhenRefreshActionCompletesWithMessagesTheSceneIsToldToShowTheMessagesList() {
        context.privateMessagesService.succeedLastRefresh(messages: [StubMessage.random])
        XCTAssertTrue(context.scene.didShowMessages)
    }

    func testWhenRefreshActionCompletesWithNoMessagesTheSceneIsToldShowTheNoMessagesPlaceholder() {
        context.privateMessagesService.succeedLastRefresh()
        XCTAssertTrue(context.scene.didShowNoMessagesPlaceholder)
    }

    func testWhenRefreshActionCompletesWithMessagesTheSceneIsNotToldShowTheNoMessagesPlaceholder() {
        context.privateMessagesService.succeedLastRefresh(messages: [StubMessage.random])
        XCTAssertFalse(context.scene.didShowNoMessagesPlaceholder)
    }

    func testWhenRefreshActionCompletesWithMessageTheSceneIsToldHideTheNoMessagesPlaceholder() {
        context.privateMessagesService.succeedLastRefresh(messages: [StubMessage.random])
        XCTAssertTrue(context.scene.didHideNoMessagesPlaceholder)
    }

    func testWhenRefreshActionCompletesWithNoMessagesTheSceneIsNotToldHideTheNoMessagesPlaceholder() {
        context.privateMessagesService.succeedLastRefresh()
        XCTAssertFalse(context.scene.didHideNoMessagesPlaceholder)
    }

    func testWhenRefreshActionCompletesWithMessagesTheSceneIsToldToBindWithTheNumberOfMessages() {
        let messages = [StubMessage].random
        context.privateMessagesService.succeedLastRefresh(messages: messages)

        XCTAssertEqual(messages.count, context.scene.boundMessageCount)
    }

    func testWhenRefreshActionCompletesWithMessagesTheSceneIsToldToBindWithTheMessage() {
        let message = StubMessage.random
        context.privateMessagesService.succeedLastRefresh(messages: [message])
        let component = CapturingMessageItemScene()
        context.scene.capturedMessageItemBinder?.bind(component, toMessageAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(message.subject, component.capturedSubject)
    }

}
