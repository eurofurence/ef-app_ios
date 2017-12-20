//
//  WhenRequestingPrivateMessagesWhileAuthenticated.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenRequestingPrivateMessagesWhileAuthenticated: XCTestCase {
    
    var context: ApplicationTestBuilder.Context!
    var capturingMessagesObserver: CapturingPrivateMessagesObserver!
    var credential: LoginCredential!
    
    override func setUp() {
        super.setUp()
        
        credential = LoginCredential(username: "",
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
    
    func testTheAuthTokenFromTheLoginCredentialShouldBeUsedWhenLoadingMessages() {
        XCTAssertEqual(credential.authenticationToken, context.privateMessagesAPI.capturedAuthToken)
    }
    
    func testReceievingAPIResponseWithSuccessShouldPropogateAuthorNameForMessage() {
        let authorName = "Some guy"
        let message = StubAPIPrivateMessage(authorName: authorName)
        let response = StubAPIPrivateMessagesResponse(messages: [message])
        context.privateMessagesAPI.simulateSuccessfulResponse(response: response)
        
        XCTAssertEqual(authorName, capturingMessagesObserver.capturedMessages?.first?.authorName)
    }
    
    func testReceievingAPIResponseWithSuccessShouldPropogatereceivedDateTimeForMessage() {
        let receivedDateTime = Date.distantPast
        let message = StubAPIPrivateMessage(receivedDateTime: receivedDateTime)
        let response = StubAPIPrivateMessagesResponse(messages: [message])
        context.privateMessagesAPI.simulateSuccessfulResponse(response: response)
        
        XCTAssertEqual(receivedDateTime, capturingMessagesObserver.capturedMessages?.first?.receivedDateTime)
    }
    
    func testReceievingAPIResponseWithSuccessShouldPropogateContentsForMessage() {
        let contents = "Blah blah important stuff blah blah"
        let message = StubAPIPrivateMessage(message: contents)
        let response = StubAPIPrivateMessagesResponse(messages: [message])
        context.privateMessagesAPI.simulateSuccessfulResponse(response: response)
        
        XCTAssertEqual(contents, capturingMessagesObserver.capturedMessages?.first?.contents)
    }
    
    func testReceievingAPIResponseWithSuccessShouldPropogateSubjectForMessage() {
        let subject = "You won something!!"
        let message = StubAPIPrivateMessage(subject: subject)
        let response = StubAPIPrivateMessagesResponse(messages: [message])
        context.privateMessagesAPI.simulateSuccessfulResponse(response: response)
        
        XCTAssertEqual(subject, capturingMessagesObserver.capturedMessages?.first?.subject)
    }
    
    func testReceivingMessageWithoutReadTimeShouldIndicateItIsNotRead() {
        let message = StubAPIPrivateMessage(readDateTime: nil)
        let response = StubAPIPrivateMessagesResponse(messages: [message])
        context.privateMessagesAPI.simulateSuccessfulResponse(response: response)
        
        XCTAssertEqual(false, capturingMessagesObserver.capturedMessages?.first?.isRead)
    }
    
    func testReceivingMessageWithReadTimeShouldIndicateItIsRead() {
        let message = StubAPIPrivateMessage(readDateTime: .distantPast)
        let response = StubAPIPrivateMessagesResponse(messages: [message])
        context.privateMessagesAPI.simulateSuccessfulResponse(response: response)
        
        XCTAssertEqual(true, capturingMessagesObserver.capturedMessages?.first?.isRead)
    }
    
}
