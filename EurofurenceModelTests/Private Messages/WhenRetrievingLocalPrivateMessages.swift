//
//  WhenRetrievingLocalPrivateMessages.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenRetrievingLocalPrivateMessages: XCTestCase {

    func testLoadingMessagesThenRequestingLocalVersionShouldReturnMessage() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let receivedDate = Date()
        let expected = APIMessage(identifier: "ID",
                               authorName: "Author",
                               receivedDateTime: receivedDate,
                               subject: "Subject",
                               contents: "Contents",
                               isRead: false)
        context.application.refreshMessages()
        context.privateMessagesAPI.simulateSuccessfulResponse(response: [expected])

        XCTAssertEqual([expected], context.application.localMessages)
    }

}
