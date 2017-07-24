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
    
    func testBeingLoggedOutShouldProvideEmptyMessages() {
        let context = ApplicationTestBuilder().build()
        let capturingMessagesObserver = CapturingPrivateMessagesObserver()
        context.application.add(capturingMessagesObserver)
        context.application.fetchPrivateMessages()
        
        XCTAssertEqual(0, capturingMessagesObserver.capturedMessages?.count)
    }
    
    func testBeingLoggedOutShouldNotProvideEmptyMessagesUntilAskingToLoadThem() {
        let context = ApplicationTestBuilder().build()
        let capturingMessagesObserver = CapturingPrivateMessagesObserver()
        context.application.add(capturingMessagesObserver)
        
        XCTAssertNil(capturingMessagesObserver.capturedMessages)
    }
    
}
