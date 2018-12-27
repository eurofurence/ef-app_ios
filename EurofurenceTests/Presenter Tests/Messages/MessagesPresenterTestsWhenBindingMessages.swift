//
//  MessagesPresenterTestsWhenBindingMessages.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceAppCoreTestDoubles
import XCTest

class MessagesPresenterTestsWhenBindingMessages: XCTestCase {

    var context: MessagesPresenterTestContext!
    var allMessages: [Message]!
    var message: Message!
    var capturingMessageScene: CapturingMessageItemScene!

    override func setUp() {
        super.setUp()
        prepareTestCase()
    }

    private func prepareTestCase(messageMutations mutations: ((inout Message) -> Void)? = nil) {
        allMessages = AppDataBuilder.makeRandomNumberOfMessages()
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

        XCTAssertTrue(capturingMessageScene.didShowUnreadIndicator)
    }

    func testTheSceneIsNotToldToShowUnreadIndicatorForReadMessage() {
        prepareTestCase { (message) in
            message.isRead = true
        }

        XCTAssertFalse(capturingMessageScene.didShowUnreadIndicator)
    }

    func testTheSceneIsToldToHideUnreadIndicatorForReadMessage() {
        prepareTestCase { (message) in
            message.isRead = true
        }

        XCTAssertTrue(capturingMessageScene.didHideUnreadIndicator)
    }

    func testTheSceneIsNotToldToHideUnreadIndicatorForUnreadMessage() {
        prepareTestCase { (message) in
            message.isRead = false
        }

        XCTAssertFalse(capturingMessageScene.didHideUnreadIndicator)
    }

}
