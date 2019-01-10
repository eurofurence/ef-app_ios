//
//  WhenLaunchingApplication_PrivateMessagesShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 10/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenLaunchingApplication_PrivateMessagesShould: XCTestCase {

    func testBeRefreshed() {
        let message = APIMessage.random
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        context.privateMessagesAPI.simulateSuccessfulResponse(response: [message])
        let observer = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(observer)
        let observedMessage = observer.observedMessages.first

        XCTAssertEqual(message.authorName, observedMessage?.authorName)
        XCTAssertEqual(message.receivedDateTime, observedMessage?.receivedDateTime)
        XCTAssertEqual(message.subject, observedMessage?.subject)
        XCTAssertEqual(message.contents, observedMessage?.contents)
        XCTAssertEqual(message.isRead, observedMessage?.isRead)
    }

    func testProvideZeroCountForNumberOfUnreadPrivateMessages() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(observer)

        XCTAssertEqual(0, observer.observedUnreadMessageCount)
    }

}
