//
//  WhenLoggingOut_PrivateMessagesShould.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 19/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenLoggingOut_PrivateMessagesShould: XCTestCase {

    func testBeCleared() {
        let observer = CapturingPrivateMessagesObserver()
        let context = EurofurenceSessionTestBuilder().build()
        context.privateMessagesService.add(observer)
        context.loginSuccessfully()
        context.privateMessagesService.refreshMessages()
        context.api.simulateMessagesResponse(response: .random)
        context.logoutSuccessfully()
        
        XCTAssertTrue(observer.observedMessages.isEmpty)
    }

}
