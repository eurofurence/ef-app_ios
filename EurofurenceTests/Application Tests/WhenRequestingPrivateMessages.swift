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
        context.application.add(privateMessagesObserver: capturingMessagesObserver)
        context.application.fetchPrivateMessages()
        
        XCTAssertTrue(capturingMessagesObserver.wasToldUserNotAuthenticated)
    }
    
    func testBeingLoggedInShouldNotTellObserversUserNotAuthenticated() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let capturingMessagesObserver = CapturingPrivateMessagesObserver()
        context.application.add(privateMessagesObserver: capturingMessagesObserver)
        context.application.fetchPrivateMessages()
        
        XCTAssertFalse(capturingMessagesObserver.wasToldUserNotAuthenticated)
    }
    
    func testBeingLoggedInShouldRequestPrivateMessagesFromAPI() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        context.application.fetchPrivateMessages()
        
        XCTAssertTrue(context.privateMessagesAPI.wasToldToLoadPrivateMessages)
    }
    
    func testBeingLoggedOutShouldNotRequestPrivateMessagesFromAPI() {
        let context = ApplicationTestBuilder().build()
        context.application.fetchPrivateMessages()
        
        XCTAssertFalse(context.privateMessagesAPI.wasToldToLoadPrivateMessages)
    }
    
    func testReceievingAPIResponseWithErrorShouldTellObserversFailedToLoadPrivateMessages() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.add(privateMessagesObserver: observer)
        context.application.fetchPrivateMessages()
        context.privateMessagesAPI.simulateUnsuccessfulResponse()
        
        XCTAssertTrue(observer.wasToldFailedToLoadPrivateMessages)
    }
    
    func testReceievingAPIResponseWithSuccessShouldNotTellObserversFailedToLoadPrivateMessages() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.add(privateMessagesObserver: observer)
        context.application.fetchPrivateMessages()
        context.privateMessagesAPI.simulateSuccessfulResponse()
        
        XCTAssertFalse(observer.wasToldFailedToLoadPrivateMessages)
    }
    
    func testReceievingAPIResponseWithSuccessShouldTellObserversSuccessullyLoadedPrivateMessages() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.add(privateMessagesObserver: observer)
        context.application.fetchPrivateMessages()
        context.privateMessagesAPI.simulateSuccessfulResponse()
        
        XCTAssertTrue(observer.wasToldSuccessfullyLoadedPrivateMessages)
    }
    
    func testRequestingPrivateMessagesWhenLoggedInShouldNotImmediatleyTellUsItLoadedMessagesBeforeAPIReturns() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.add(privateMessagesObserver: observer)
        context.application.fetchPrivateMessages()
        
        XCTAssertFalse(observer.wasToldSuccessfullyLoadedPrivateMessages)
    }
    
    func testReceievingAPIResponseWithErrorShouldNotTellObserversSuccessfullyLoadedPrivateMessages() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.add(privateMessagesObserver: observer)
        context.application.fetchPrivateMessages()
        context.privateMessagesAPI.simulateUnsuccessfulResponse()
        
        XCTAssertFalse(observer.wasToldSuccessfullyLoadedPrivateMessages)
    }
    
    func testRequestingPrivateMessagesShouldUseTheAuthTokenFromTheLoginCredential() {
        let authToken = "Some super secret stuff"
        let credential = LoginCredential(username: "", registrationNumber: 0, authenticationToken: authToken, tokenExpiryDate: .distantFuture)
        let context = ApplicationTestBuilder().with(credential).build()
        context.application.fetchPrivateMessages()
        
        XCTAssertEqual(authToken, context.privateMessagesAPI.capturedAuthToken)
    }
    
    func testReceievingAPIResponseWithSuccessShouldPropogateAuthorNameForMessage() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.add(privateMessagesObserver: observer)
        context.application.fetchPrivateMessages()
        let authorName = "Some guy"
        let message = StubAPIPrivateMessage(authorName: authorName)
        let response = StubAPIPrivateMessagesResponse(messages: [message])
        context.privateMessagesAPI.simulateSuccessfulResponse(response: response)
        
        XCTAssertEqual(authorName, observer.capturedMessages?.first?.authorName)
    }
    
    func testReceievingAPIResponseWithSuccessShouldPropogatereceivedDateTimeForMessage() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.add(privateMessagesObserver: observer)
        context.application.fetchPrivateMessages()
        let receivedDateTime = Date.distantPast
        let message = StubAPIPrivateMessage(receivedDateTime: receivedDateTime)
        let response = StubAPIPrivateMessagesResponse(messages: [message])
        context.privateMessagesAPI.simulateSuccessfulResponse(response: response)
        
        XCTAssertEqual(receivedDateTime, observer.capturedMessages?.first?.receivedDateTime)
    }
    
    func testReceievingAPIResponseWithSuccessShouldPropogateContentsForMessage() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.add(privateMessagesObserver: observer)
        context.application.fetchPrivateMessages()
        let contents = "Blah blah important stuff blah blah"
        let message = StubAPIPrivateMessage(message: contents)
        let response = StubAPIPrivateMessagesResponse(messages: [message])
        context.privateMessagesAPI.simulateSuccessfulResponse(response: response)
        
        XCTAssertEqual(contents, observer.capturedMessages?.first?.contents)
    }
    
}
