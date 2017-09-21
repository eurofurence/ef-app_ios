//
//  MessagesPresenterTestsWhenBindingMessages.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
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
        let randomIndex = Random.makeRandomNumber(upperLimit: allMessages.count)
        let randomIndexPath = IndexPath(row: randomIndex, section: 0)
        var randomMessage = allMessages[randomIndex]
        mutations?(&randomMessage)
        allMessages[randomIndex] = randomMessage
        self.message = randomMessage
        
        let service = CapturingPrivateMessagesService(localMessages: allMessages)
        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        capturingMessageScene = CapturingMessageItemScene()
        context.scene.capturedMessageItemBinder?.bind(capturingMessageScene, toMessageAt: randomIndexPath)
    }
    
    func testTheSceneIsProvidedWithTheMessageCountThroughTheBinder() {
        XCTAssertEqual(allMessages.count, context.scene.capturedMessageItemBinder?.numberOfMessages)
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
        prepareTestCase() { (message) in
            message.isRead = false
        }
        
        XCTAssertTrue(capturingMessageScene.didShowUnreadIndicator)
    }
    
    func testTheSceneIsNotToldToShowUnreadIndicatorForReadMessage() {
        prepareTestCase() { (message) in
            message.isRead = true
        }
        
        XCTAssertFalse(capturingMessageScene.didShowUnreadIndicator)
    }
    
    func testTheSceneIsToldToHideUnreadIndicatorForReadMessage() {
        prepareTestCase() { (message) in
            message.isRead = true
        }
        
        XCTAssertTrue(capturingMessageScene.didHideUnreadIndicator)
    }
    
    func testTheSceneIsNotToldToHideUnreadIndicatorForUnreadMessage() {
        prepareTestCase() { (message) in
            message.isRead = false
        }
        
        XCTAssertFalse(capturingMessageScene.didHideUnreadIndicator)
    }
    
}
