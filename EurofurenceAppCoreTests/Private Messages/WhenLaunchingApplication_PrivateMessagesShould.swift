//
//  WhenLaunchingApplication_PrivateMessagesShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 10/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenLaunchingApplication_PrivateMessagesShould: XCTestCase {

    func testBeRefreshed() {
        let messages = [Message].random
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        context.privateMessagesAPI.simulateSuccessfulResponse(response: messages)
        let observer = CapturingPrivateMessagesObserver()
        context.application.add(observer)

        XCTAssertTrue(observer.observedMessages.contains(elementsFrom: messages))
    }

}
