//
//  WhenRequestingPrivateMessages.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenRequestingPrivateMessages: XCTestCase {
    
    func testBeingLoggedOutShouldTellObserversUserNotAuthenticated() {
        let context = ApplicationTestBuilder().build()
        let capturingMessagesObserver = CapturingPrivateMessagesObserver()
        context.application.fetchPrivateMessages(completionHandler: capturingMessagesObserver.completionHandler)
        
        XCTAssertTrue(capturingMessagesObserver.wasToldUserNotAuthenticated)
    }
    
    func testBeingLoggedInShouldNotTellObserversUserNotAuthenticated() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let capturingMessagesObserver = CapturingPrivateMessagesObserver()
        context.application.fetchPrivateMessages(completionHandler: capturingMessagesObserver.completionHandler)
        
        XCTAssertFalse(capturingMessagesObserver.wasToldUserNotAuthenticated)
    }
    
    func testBeingLoggedInShouldRequestPrivateMessagesFromAPI() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        context.application.fetchPrivateMessages() { _ in }
        
        XCTAssertTrue(context.privateMessagesAPI.wasToldToLoadPrivateMessages)
    }
    
    func testBeingLoggedOutShouldNotRequestPrivateMessagesFromAPI() {
        let context = ApplicationTestBuilder().build()
        context.application.fetchPrivateMessages() { _ in }
        
        XCTAssertFalse(context.privateMessagesAPI.wasToldToLoadPrivateMessages)
    }
    
    func testReceievingAPIResponseWithErrorShouldTellObserversFailedToLoadPrivateMessages() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.fetchPrivateMessages(completionHandler: observer.completionHandler)
        context.privateMessagesAPI.simulateUnsuccessfulResponse()
        
        XCTAssertTrue(observer.wasToldFailedToLoadPrivateMessages)
    }
    
    func testReceievingAPIResponseWithSuccessShouldNotTellObserversFailedToLoadPrivateMessages() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.fetchPrivateMessages(completionHandler: observer.completionHandler)
        context.privateMessagesAPI.simulateSuccessfulResponse()
        
        XCTAssertFalse(observer.wasToldFailedToLoadPrivateMessages)
    }
    
    func testReceievingAPIResponseWithSuccessShouldTellObserversSuccessullyLoadedPrivateMessages() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.fetchPrivateMessages(completionHandler: observer.completionHandler)
        context.privateMessagesAPI.simulateSuccessfulResponse()
        
        XCTAssertTrue(observer.wasToldSuccessfullyLoadedPrivateMessages)
    }
    
    func testRequestingPrivateMessagesWhenLoggedInShouldNotImmediatleyTellUsItLoadedMessagesBeforeAPIReturns() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.fetchPrivateMessages(completionHandler: observer.completionHandler)
        
        XCTAssertFalse(observer.wasToldSuccessfullyLoadedPrivateMessages)
    }
    
    func testReceievingAPIResponseWithErrorShouldNotTellObserversSuccessfullyLoadedPrivateMessages() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.fetchPrivateMessages(completionHandler: observer.completionHandler)
        context.privateMessagesAPI.simulateUnsuccessfulResponse()
        
        XCTAssertFalse(observer.wasToldSuccessfullyLoadedPrivateMessages)
    }
    
    func testRequestingPrivateMessagesShouldUseTheAuthTokenFromTheLoginCredential() {
        let authToken = "Some super secret stuff"
        let credential = LoginCredential(username: "", registrationNumber: 0, authenticationToken: authToken, tokenExpiryDate: .distantFuture)
        let context = ApplicationTestBuilder().with(credential).build()
        context.application.fetchPrivateMessages(completionHandler: { _ in })
        
        XCTAssertEqual(authToken, context.privateMessagesAPI.capturedAuthToken)
    }
    
    func testReceievingAPIResponseWithSuccessShouldPropogateAuthorNameForMessage() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.fetchPrivateMessages(completionHandler: observer.completionHandler)
        let authorName = "Some guy"
        let message = StubAPIPrivateMessage(authorName: authorName)
        let response = StubAPIPrivateMessagesResponse(messages: [message])
        context.privateMessagesAPI.simulateSuccessfulResponse(response: response)
        
        XCTAssertEqual(authorName, observer.capturedMessages?.first?.authorName)
    }
    
    func testReceievingAPIResponseWithSuccessShouldPropogatereceivedDateTimeForMessage() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.fetchPrivateMessages(completionHandler: observer.completionHandler)
        let receivedDateTime = Date.distantPast
        let message = StubAPIPrivateMessage(receivedDateTime: receivedDateTime)
        let response = StubAPIPrivateMessagesResponse(messages: [message])
        context.privateMessagesAPI.simulateSuccessfulResponse(response: response)
        
        XCTAssertEqual(receivedDateTime, observer.capturedMessages?.first?.receivedDateTime)
    }
    
    func testReceievingAPIResponseWithSuccessShouldPropogateContentsForMessage() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.fetchPrivateMessages(completionHandler: observer.completionHandler)
        let contents = "Blah blah important stuff blah blah"
        let message = StubAPIPrivateMessage(message: contents)
        let response = StubAPIPrivateMessagesResponse(messages: [message])
        context.privateMessagesAPI.simulateSuccessfulResponse(response: response)
        
        XCTAssertEqual(contents, observer.capturedMessages?.first?.contents)
    }
    
    func testReceievingAPIResponseWithSuccessShouldPropogateSubjectForMessage() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.fetchPrivateMessages(completionHandler: observer.completionHandler)
        let subject = "You won something!!"
        let message = StubAPIPrivateMessage(subject: subject)
        let response = StubAPIPrivateMessagesResponse(messages: [message])
        context.privateMessagesAPI.simulateSuccessfulResponse(response: response)
        
        XCTAssertEqual(subject, observer.capturedMessages?.first?.subject)
    }
    
    func testReceivingMessageWithoutReadTimeShouldIndicateItIsNotRead() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.fetchPrivateMessages(completionHandler: observer.completionHandler)
        let message = StubAPIPrivateMessage(readDateTime: nil)
        let response = StubAPIPrivateMessagesResponse(messages: [message])
        context.privateMessagesAPI.simulateSuccessfulResponse(response: response)
        
        XCTAssertEqual(false, observer.capturedMessages?.first?.isRead)
    }
    
    func testReceivingMessageWithReadTimeShouldIndicateItIsRead() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.fetchPrivateMessages(completionHandler: observer.completionHandler)
        let message = StubAPIPrivateMessage(readDateTime: .distantPast)
        let response = StubAPIPrivateMessagesResponse(messages: [message])
        context.privateMessagesAPI.simulateSuccessfulResponse(response: response)
        
        XCTAssertEqual(true, observer.capturedMessages?.first?.isRead)
    }
    
}
