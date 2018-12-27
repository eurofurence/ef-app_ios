//
//  WhenMarkingMessageAsRead.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenMarkingMessageAsRead: XCTestCase {

    func testItShouldTellTheMarkAsReadAPIToMarkTheIdentifierOfTheMessageAsRead() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.fetchPrivateMessages(completionHandler: observer.completionHandler)
        let identifier = "Message ID"
        context.privateMessagesAPI.simulateSuccessfulResponse(response: [AppDataBuilder.makeMessage(identifier: identifier)])

        if let receievedMessage = observer.capturedMessages?.first {
            context.application.markMessageAsRead(receievedMessage)
        }

        XCTAssertEqual(identifier, context.privateMessagesAPI.messageIdentifierMarkedAsRead)
    }

    func testItShouldSupplyTheUsersAuthenticationTokenToTheMarkAsReadAPI() {
        let authenticationToken = "Some auth token"
        let credential = Credential(username: "", registrationNumber: 0, authenticationToken: authenticationToken, tokenExpiryDate: .distantFuture)
        let context = ApplicationTestBuilder().with(credential).build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.fetchPrivateMessages(completionHandler: observer.completionHandler)
        let identifier = "Message ID"
        context.privateMessagesAPI.simulateSuccessfulResponse(response: [AppDataBuilder.makeMessage(identifier: identifier)])

        if let receievedMessage = observer.capturedMessages?.first {
            context.application.markMessageAsRead(receievedMessage)
        }

        XCTAssertEqual(authenticationToken, context.privateMessagesAPI.capturedAuthTokenForMarkingMessageAsRead)
    }

}
