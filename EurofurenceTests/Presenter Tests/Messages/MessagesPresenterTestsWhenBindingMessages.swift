//
//  MessagesPresenterTestsWhenBindingMessages.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class MessagesPresenterTestsWhenBindingMessages: XCTestCase {

    var context: MessagesPresenterTestContext!
    var allMessages: [StubMessage]!
    var message: Message!
    var capturingMessageScene: CapturingMessageItemScene!

    override func setUp() {
        super.setUp()
        prepareTestCase()
    }

    private func prepareTestCase(messageMutations mutations: ((inout StubMessage) -> Void)? = nil) {
        allMessages = .random
        let randomIndex = Int.random(upperLimit: UInt32(allMessages.count))
        let randomIndexPath = IndexPath(row: randomIndex, section: 0)
        var randomMessage = allMessages[randomIndex]
        mutations?(&randomMessage)
        allMessages[randomIndex] = randomMessage
        self.message = randomMessage

        let service = CapturingPrivateMessagesService(localMessages: allMessages)
        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        context.scene.delegate?.messagesSceneWillAppear()
        context.privateMessagesService.succeedLastRefresh(messages: allMessages)
        capturingMessageScene = CapturingMessageItemScene()
        context.scene.capturedMessageItemBinder?.bind(capturingMessageScene, toMessageAt: randomIndexPath)
    }

    func testTheSceneIsProvidedWithTheMessageCount() {
        XCTAssertEqual(allMessages.count, context.scene.boundMessageCount)
    }

    func testTheSceneIsProvidedWithTheAuthor() {
        XCTAssertEqual(message.authorName, capturingMessageScene.capturedAuthor)
    }

    func testTheSceneIsProvidedWithTheSubject() {
        XCTAssertEqual(message.subject, capturingMessageScene.capturedSubject)
    }

    func testTheSceneIsProvidedWithTheContents() {
        XCTAssertEqual(message.contents, capturingMessageScene.capturedContents)
    }

    func testTheReceivedDateIsProvidedToTheDateFormatter() {
        XCTAssertEqual(message.receivedDateTime, context.dateFormatter.capturedDate)
    }

    func testTheProducedStringFromTheDateFormatterIsProvidedToTheScene() {
        XCTAssertEqual(context.dateFormatter.stubString, capturingMessageScene.capturedReceivedDateTime)
    }

    func testTheSceneIsToldToShowUnreadIndicatorForUnreadMessage() {
        prepareTestCase { (message) in
            message.isRead = false
        }

        XCTAssertEqual(capturingMessageScene.unreadIndicatorVisibility, .visible)
    }

    func testTheSceneIsToldToHideUnreadIndicatorForReadMessage() {
        prepareTestCase { (message) in
            message.isRead = true
        }

        XCTAssertEqual(capturingMessageScene.unreadIndicatorVisibility, .hidden)
    }

}
