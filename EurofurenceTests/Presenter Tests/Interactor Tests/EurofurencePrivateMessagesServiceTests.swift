//
//  EurofurencePrivateMessagesServiceTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

struct EurofurencePrivateMessagesService: PrivateMessagesService {
    
    private let app: EurofurenceApplicationProtocol
    
    init(app: EurofurenceApplicationProtocol) {
        self.app = app
    }
    
    var unreadMessageCount: Int {
        return app.localPrivateMessages.filter(isUnread).count
    }
    
    private func isUnread(_ message: Message) -> Bool {
        return !message.isRead
    }
    
}

class EurofurencePrivateMessagesServiceTests: XCTestCase {
    
    var service: EurofurencePrivateMessagesService!
    var app: CapturingEurofurenceApplication!
    
    override func setUp() {
        super.setUp()
        
        app = CapturingEurofurenceApplication()
        service = EurofurencePrivateMessagesService(app: app)
    }
    
    private func makeMessage(read: Bool) -> Message {
        return Message(identifier: "", authorName: "", receivedDateTime: Date(), subject: "", contents: "", isRead: read)
    }
    
    func testUnreadCountEqualsExpectedCountWithUnreadMessages() {
        let unreadMessageCount = Random.makeRandomNumber(upperLimit: 10)
        let messages = (0..<unreadMessageCount).map({ _ in makeMessage(read: false) })
        app.localPrivateMessages = messages
        
        XCTAssertEqual(unreadMessageCount, service.unreadMessageCount)
    }
    
    func testUnreadCountEqualsOneWithTwoMessagesWhereOneIsAlreadyRead() {
        let unreadMessage = makeMessage(read: false)
        let readMessage = makeMessage(read: true)
        app.localPrivateMessages = [unreadMessage, readMessage]
        
        XCTAssertEqual(1, service.unreadMessageCount)
    }
    
}
