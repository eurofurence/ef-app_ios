//
//  WhenRequestingPrivateMessagesWhileNotAuthenticated.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenRequestingPrivateMessagesWhileNotAuthenticated: XCTestCase {

    var context: ApplicationTestBuilder.Context!
    var capturingMessagesObserver: CapturingPrivateMessagesObserver!

    override func setUp() {
        super.setUp()

        context = ApplicationTestBuilder().build()
        capturingMessagesObserver = CapturingPrivateMessagesObserver()
        context.application.add(capturingMessagesObserver)
        context.application.refreshMessages()
    }

    func testHandlerShouldBeToldFailedToLoadMessages() {
        XCTAssertTrue(capturingMessagesObserver.wasToldFailedToLoadPrivateMessages)
    }

    func testPrivateMessagesShouldNotBeFetched() {
        XCTAssertFalse(context.privateMessagesAPI.wasToldToLoadPrivateMessages)
    }

}
