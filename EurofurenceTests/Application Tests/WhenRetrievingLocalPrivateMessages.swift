//
//  WhenRetrievingLocalPrivateMessages.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
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
        let message = StubAPIPrivateMessage(id: expected.identifier,
                                            authorName: expected.authorName,
                                            subject: expected.subject,
                                            message: expected.contents,
                                            receivedDateTime: receivedDate,
                                            readDateTime: nil)
        let response = StubAPIPrivateMessagesResponse(messages: [message])
        context.application.fetchPrivateMessages { _ in }
        context.privateMessagesAPI.simulateSuccessfulResponse(response: response)
        
        XCTAssertEqual([expected], context.application.localPrivateMessages)
    }
    
}
