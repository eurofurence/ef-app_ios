//
//  WhenRetrievingLocalPrivateMessages.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Eurofurence
import XCTest

class WhenRetrievingLocalPrivateMessages: XCTestCase {
    
    func testLoadingMessagesThenRequestingLocalVersionShouldReturnMessage() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let receivedDate = Date()
        let expected = Message(identifier: "ID",
                               authorName: "Author",
                               receivedDateTime: receivedDate,
                               subject: "Subject",
                               contents: "Contents",
                               isRead: false)
        context.application.fetchPrivateMessages { (_) in }
        context.privateMessagesAPI.simulateSuccessfulResponse(response: [expected])
        
        XCTAssertEqual([expected], context.application.localPrivateMessages)
    }
    
}
