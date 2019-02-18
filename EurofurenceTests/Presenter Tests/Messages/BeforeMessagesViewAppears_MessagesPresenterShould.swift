//
//  BeforeMessagesViewAppears_MessagesPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 07/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModelTestDoubles
import XCTest

class BeforeMessagesViewAppears_MessagesPresenterShould: XCTestCase {

    func testNotTellTheSceneToPrepareMessagesForPresentation() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.privateMessagesService.succeedLastRefresh(messages: [StubMessage].random)

        XCTAssertFalse(context.scene.didShowMessages)
    }

}
