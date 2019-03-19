//
//  WhenLoggingOut_ThenRequestingPrivateMessages.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 19/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenLoggingOut_ThenRequestingPrivateMessages: XCTestCase {

    func testNoRequestIsMade() {
        let context = EurofurenceSessionTestBuilder().build()
        context.loginSuccessfully()
        context.logoutSuccessfully()
        context.privateMessagesService.refreshMessages()
        
        XCTAssertFalse(context.api.wasToldToLoadPrivateMessages)
    }

}
