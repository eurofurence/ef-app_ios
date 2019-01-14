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
        XCTAssertTrue(context.privateMessagesAPI.wasToldToLoadPrivateMessages)
    }

    func testReceievingAPIResponseWithErrorShouldTellObserversFailedToLoadPrivateMessages() {
        context.privateMessagesAPI.simulateUnsuccessfulResponse()
        XCTAssertTrue(capturingMessagesObserver.wasToldFailedToLoadPrivateMessages)
    }

    func testReceievingAPIResponseWithSuccessShouldNotTellObserversFailedToLoadPrivateMessages() {
        context.privateMessagesAPI.simulateSuccessfulResponse()
        XCTAssertFalse(capturingMessagesObserver.wasToldFailedToLoadPrivateMessages)
    }

    func testReceievingAPIResponseWithSuccessShouldTellObserversSuccessullyLoadedPrivateMessages() {
        context.privateMessagesAPI.simulateSuccessfulResponse()
        XCTAssertTrue(capturingMessagesObserver.wasToldSuccessfullyLoadedPrivateMessages)
    }

    func testItShouldNotImmediatleyTellUsItLoadedMessagesBeforeAPIReturns() {
        XCTAssertFalse(capturingMessagesObserver.wasToldSuccessfullyLoadedPrivateMessages)
    }

    func testReceievingAPIResponseWithErrorShouldNotTellObserversSuccessfullyLoadedPrivateMessages() {
        context.privateMessagesAPI.simulateUnsuccessfulResponse()
        XCTAssertFalse(capturingMessagesObserver.wasToldSuccessfullyLoadedPrivateMessages)
    }

    func testTheAuthTokenFromTheCredentialShouldBeUsedWhenLoadingMessages() {
        XCTAssertEqual(credential.authenticationToken, context.privateMessagesAPI.capturedAuthToken)
    }

    func testReceievingAPIResponseWithSuccessShouldPropogateAuthorNameForMessage() {
        let authorName = "Some guy"
        var message = MessageCharacteristics.random
        message.authorName = authorName
        context.privateMessagesAPI.simulateSuccessfulResponse(response: [message])

        XCTAssertEqual(authorName, capturingMessagesObserver.observedMessages.first?.authorName)
    }

    func testReceievingAPIResponseWithSuccessShouldPropogatereceivedDateTimeForMessage() {
        let receivedDateTime = Date.distantPast
        var message = MessageCharacteristics.random
        message.receivedDateTime = receivedDateTime
        context.privateMessagesAPI.simulateSuccessfulResponse(response: [message])

        XCTAssertEqual(receivedDateTime, capturingMessagesObserver.observedMessages.first?.receivedDateTime)
    }

    func testReceievingAPIResponseWithSuccessShouldPropogateContentsForMessage() {
        let contents = "Blah blah important stuff blah blah"
        var message = MessageCharacteristics.random
        message.contents = contents
        context.privateMessagesAPI.simulateSuccessfulResponse(response: [message])

        XCTAssertEqual(contents, capturingMessagesObserver.observedMessages.first?.contents)
    }

    func testReceievingAPIResponseWithSuccessShouldPropogateSubjectForMessage() {
        let subject = "You won something!!"
        var message = MessageCharacteristics.random
        message.subject = subject
        context.privateMessagesAPI.simulateSuccessfulResponse(response: [message])

        XCTAssertEqual(subject, capturingMessagesObserver.observedMessages.first?.subject)
    }

    func testMessagesShouldBeSortedWithLatestMessagesFirst() {
        let makeRandomMessage: () -> MessageCharacteristics = {
            let randomDate = Date(timeIntervalSinceNow: .random(upperLimit: 3600))
            var message = MessageCharacteristics.random
            message.receivedDateTime = randomDate
            return message
        }

        let messages = (0...5).map({ (_) in makeRandomMessage() })
        let expectedDateOrdering = Array(messages.map({ $0.receivedDateTime }).sorted().reversed())
        context.privateMessagesAPI.simulateSuccessfulResponse(response: messages)
        let actualDateOrdering = capturingMessagesObserver.observedMessages.map({ $0.receivedDateTime })

        XCTAssertEqual(expectedDateOrdering, actualDateOrdering)
    }

    func testObserversToldOfNewUnreadCount() {
        var unreadMessage = MessageCharacteristics.random
        unreadMessage.isRead = false
        context.privateMessagesAPI.simulateSuccessfulResponse(response: [unreadMessage])

        XCTAssertEqual(1, capturingMessagesObserver.observedUnreadMessageCount)
    }

    func testReadMessagesNotIncludedInUnreadCount() {
        var unreadMessage = MessageCharacteristics.random
        unreadMessage.isRead = false
        var readMessage = MessageCharacteristics.random
        readMessage.isRead = true
        context.privateMessagesAPI.simulateSuccessfulResponse(response: [unreadMessage, readMessage])

        XCTAssertEqual(1, capturingMessagesObserver.observedUnreadMessageCount)
    }

    func testLateAddedObserversToldOfNewUnreadCount() {
        var unreadMessage = MessageCharacteristics.random
        unreadMessage.isRead = false
        context.privateMessagesAPI.simulateSuccessfulResponse(response: [unreadMessage])

        let observer = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(observer)

        XCTAssertEqual(1, observer.observedUnreadMessageCount)
    }

}
