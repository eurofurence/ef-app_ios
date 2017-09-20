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
    var message: Message!
    var capturingMessageScene: CapturingMessageItemScene!
    
    override func setUp() {
        super.setUp()
        
        let localMessages = AppDataBuilder.makeRandomNumberOfMessages()
        let randomIndex = Random.makeRandomNumber(upperLimit: localMessages.count)
        let randomIndexPath = IndexPath(row: randomIndex, section: 0)
        
        let service = CapturingPrivateMessagesService(localMessages: localMessages)
        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        message = localMessages[randomIndex]
        capturingMessageScene = CapturingMessageItemScene()
        context.scene.capturedMessageItemBinder?.bind(capturingMessageScene, toMessageAt: randomIndexPath)
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
    
}
