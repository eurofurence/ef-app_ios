//
//  WhenMarkingMessageAsRead.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenMarkingMessageAsRead: XCTestCase {

    func testItShouldTellTheMarkAsReadAPIToMarkTheIdentifierOfTheMessageAsRead() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(observer)
        context.privateMessagesService.refreshMessages()
        let identifier = "Message ID"
        var message = MessageCharacteristics.random
        message.identifier = identifier
        context.privateMessagesAPI.simulateSuccessfulResponse(response: [message])

        if let receievedMessage = observer.observedMessages.first {
            context.privateMessagesService.markMessageAsRead(receievedMessage)
        }

        XCTAssertEqual(identifier, context.privateMessagesAPI.messageIdentifierMarkedAsRead)
    }

    func testItShouldSupplyTheUsersAuthenticationTokenToTheMarkAsReadAPI() {
        let authenticationToken = "Some auth token"
        let credential = Credential(username: "", registrationNumber: 0, authenticationToken: authenticationToken, tokenExpiryDate: .distantFuture)
        let context = ApplicationTestBuilder().with(credential).build()
        let observer = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(observer)
        context.privateMessagesService.refreshMessages()
        let identifier = "Message ID"
        var message = MessageCharacteristics.random
        message.identifier = identifier
        context.privateMessagesAPI.simulateSuccessfulResponse(response: [message])

        if let receievedMessage = observer.observedMessages.first {
            context.privateMessagesService.markMessageAsRead(receievedMessage)
        }

        XCTAssertEqual(authenticationToken, context.privateMessagesAPI.capturedAuthTokenForMarkingMessageAsRead)
    }

    func testItShouldNotifyObserversUnreadMessageCountChanged() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(observer)
        context.privateMessagesService.refreshMessages()
        let message = MessageCharacteristics.random
        context.privateMessagesAPI.simulateSuccessfulResponse(response: [message])
        context.privateMessagesService.markMessageAsRead(message)

        XCTAssertEqual(0, observer.observedUnreadMessageCount)
    }

}
