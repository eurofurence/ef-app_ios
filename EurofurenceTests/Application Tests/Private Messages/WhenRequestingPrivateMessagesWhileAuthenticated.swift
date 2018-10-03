//
//  WhenRequestingPrivateMessagesWhileAuthenticated.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Eurofurence
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
        context.application.fetchPrivateMessages(completionHandler: capturingMessagesObserver.completionHandler)
    }
    
    func testHandlerShouldNotBeGivenNotAuthenticatedResponse() {
        XCTAssertFalse(capturingMessagesObserver.wasToldUserNotAuthenticated)
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
        let message = AppDataBuilder.makeMessage(authorName: authorName)
        context.privateMessagesAPI.simulateSuccessfulResponse(response: [message])
        
        XCTAssertEqual(authorName, capturingMessagesObserver.capturedMessages?.first?.authorName)
    }
    
    func testReceievingAPIResponseWithSuccessShouldPropogatereceivedDateTimeForMessage() {
        let receivedDateTime = Date.distantPast
        let message = AppDataBuilder.makeMessage(receivedDateTime: receivedDateTime)
        context.privateMessagesAPI.simulateSuccessfulResponse(response: [message])
        
        XCTAssertEqual(receivedDateTime, capturingMessagesObserver.capturedMessages?.first?.receivedDateTime)
    }
    
    func testReceievingAPIResponseWithSuccessShouldPropogateContentsForMessage() {
        let contents = "Blah blah important stuff blah blah"
        let message = AppDataBuilder.makeMessage(contents: contents)
        context.privateMessagesAPI.simulateSuccessfulResponse(response: [message])
        
        XCTAssertEqual(contents, capturingMessagesObserver.capturedMessages?.first?.contents)
    }
    
    func testReceievingAPIResponseWithSuccessShouldPropogateSubjectForMessage() {
        let subject = "You won something!!"
        let message = AppDataBuilder.makeMessage(subject: subject)
        context.privateMessagesAPI.simulateSuccessfulResponse(response: [message])
        
        XCTAssertEqual(subject, capturingMessagesObserver.capturedMessages?.first?.subject)
    }
    
    func testMessagesShouldBeSortedWithLatestMessagesFirst() {
        let makeRandomMessage: () -> Message = {
            let randomDate = Date(timeIntervalSinceNow: .random(upperLimit: 3600))
            return AppDataBuilder.makeMessage(receivedDateTime: randomDate)
        }
        
        let messages = (0...5).map({ (_) in makeRandomMessage() })
        let expectedDateOrdering = Array(messages.map({ $0.receivedDateTime }).sorted().reversed())
        context.privateMessagesAPI.simulateSuccessfulResponse(response: messages)
        let actualDateOrdering = capturingMessagesObserver.capturedMessages?.map({ $0.receivedDateTime }) ?? []
        
        XCTAssertEqual(expectedDateOrdering, actualDateOrdering)
    }
    
}
