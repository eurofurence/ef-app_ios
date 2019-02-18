//
//  WhenRequestingPrivateMessagesWhileAuthenticated.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenRequestingPrivateMessagesWhileAuthenticated: XCTestCase {

    var context: ApplicationTestBuilder.Context!
    var capturingMessagesObserver: CapturingPrivateMessagesObserver!
    var credential: Credential!

    override func setUp() {
        super.setUp()

        credential = Credential(username: "",
                                     registrationNumber: 0,
                                     authenticationToken: "Some super secret stuff",
                                     tokenExpiryDate: .distantFuture)
        context = ApplicationTestBuilder().with(credential).build()
        capturingMessagesObserver = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(capturingMessagesObserver)
        capturingMessagesObserver.wasToldSuccessfullyLoadedPrivateMessages = false
        context.privateMessagesService.refreshMessages()
    }

    func testPrivateMessagesAPIShouldLoad() {
        XCTAssertTrue(context.api.wasToldToLoadPrivateMessages)
    }

    func testReceievingAPIResponseWithErrorShouldTellObserversFailedToLoadPrivateMessages() {
        context.api.simulateMessagesFailure()
        XCTAssertTrue(capturingMessagesObserver.wasToldFailedToLoadPrivateMessages)
    }

    func testReceievingAPIResponseWithSuccessShouldNotTellObserversFailedToLoadPrivateMessages() {
        context.api.simulateMessagesResponse()
        XCTAssertFalse(capturingMessagesObserver.wasToldFailedToLoadPrivateMessages)
    }

    func testReceievingAPIResponseWithSuccessShouldTellObserversSuccessullyLoadedPrivateMessages() {
        context.api.simulateMessagesResponse()
        XCTAssertTrue(capturingMessagesObserver.wasToldSuccessfullyLoadedPrivateMessages)
    }

    func testItShouldNotImmediatleyTellUsItLoadedMessagesBeforeAPIReturns() {
        XCTAssertFalse(capturingMessagesObserver.wasToldSuccessfullyLoadedPrivateMessages)
    }

    func testReceievingAPIResponseWithErrorShouldNotTellObserversSuccessfullyLoadedPrivateMessages() {
        context.api.simulateMessagesFailure()
        XCTAssertFalse(capturingMessagesObserver.wasToldSuccessfullyLoadedPrivateMessages)
    }

    func testTheAuthTokenFromTheCredentialShouldBeUsedWhenLoadingMessages() {
        XCTAssertEqual(credential.authenticationToken, context.api.capturedAuthToken)
    }

    func testReceievingAPIResponseWithSuccessShouldPropogateAuthorNameForMessage() {
        let authorName = "Some guy"
        var message = MessageEntity.random
        message.authorName = authorName
        context.api.simulateMessagesResponse(response: [message])

        XCTAssertEqual(authorName, capturingMessagesObserver.observedMessages.first?.authorName)
    }

    func testReceievingAPIResponseWithSuccessShouldPropogatereceivedDateTimeForMessage() {
        let receivedDateTime = Date.distantPast
        var message = MessageEntity.random
        message.receivedDateTime = receivedDateTime
        context.api.simulateMessagesResponse(response: [message])

        XCTAssertEqual(receivedDateTime, capturingMessagesObserver.observedMessages.first?.receivedDateTime)
    }

    func testReceievingAPIResponseWithSuccessShouldPropogateContentsForMessage() {
        let contents = "Blah blah important stuff blah blah"
        var message = MessageEntity.random
        message.contents = contents
        context.api.simulateMessagesResponse(response: [message])

        XCTAssertEqual(contents, capturingMessagesObserver.observedMessages.first?.contents)
    }

    func testReceievingAPIResponseWithSuccessShouldPropogateSubjectForMessage() {
        let subject = "You won something!!"
        var message = MessageEntity.random
        message.subject = subject
        context.api.simulateMessagesResponse(response: [message])

        XCTAssertEqual(subject, capturingMessagesObserver.observedMessages.first?.subject)
    }

    func testMessagesShouldBeSortedWithLatestMessagesFirst() {
        let makeRandomMessage: () -> MessageEntity = {
            let randomDate = Date(timeIntervalSinceNow: .random(upperLimit: 3600))
            var message = MessageEntity.random
            message.receivedDateTime = randomDate
            return message
        }

        let messages = (0...5).map({ (_) in makeRandomMessage() })
        let expectedDateOrdering = Array(messages.map({ $0.receivedDateTime }).sorted().reversed())
        context.api.simulateMessagesResponse(response: messages)
        let actualDateOrdering = capturingMessagesObserver.observedMessages.map({ $0.receivedDateTime })

        XCTAssertEqual(expectedDateOrdering, actualDateOrdering)
    }

    func testObserversToldOfNewUnreadCount() {
        var unreadMessage = MessageEntity.random
        unreadMessage.isRead = false
        context.api.simulateMessagesResponse(response: [unreadMessage])

        XCTAssertEqual(1, capturingMessagesObserver.observedUnreadMessageCount)
    }

    func testReadMessagesNotIncludedInUnreadCount() {
        var unreadMessage = MessageEntity.random
        unreadMessage.isRead = false
        var readMessage = MessageEntity.random
        readMessage.isRead = true
        context.api.simulateMessagesResponse(response: [unreadMessage, readMessage])

        XCTAssertEqual(1, capturingMessagesObserver.observedUnreadMessageCount)
    }

    func testLateAddedObserversToldOfNewUnreadCount() {
        var unreadMessage = MessageEntity.random
        unreadMessage.isRead = false
        context.api.simulateMessagesResponse(response: [unreadMessage])

        let observer = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(observer)

        XCTAssertEqual(1, observer.observedUnreadMessageCount)
    }

}
