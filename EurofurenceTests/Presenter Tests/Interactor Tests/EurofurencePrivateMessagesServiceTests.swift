//
//  EurofurencePrivateMessagesServiceTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class EurofurencePrivateMessagesServiceTests: XCTestCase {
    
    var service: EurofurencePrivateMessagesService!
    var app: CapturingEurofurenceApplication!
    
    override func setUp() {
        super.setUp()
        
        app = CapturingEurofurenceApplication()
        service = EurofurencePrivateMessagesService(app: app)
    }
    
    func testUnreadCountEqualsExpectedCountWithUnreadMessages() {
        let unreadMessageCount = Random.makeRandomNumber(upperLimit: 10)
        let messages = (0..<unreadMessageCount).map({ _ in AppDataBuilder.makeMessage(read: false) })
        app.localPrivateMessages = messages
        
        XCTAssertEqual(unreadMessageCount, service.unreadMessageCount)
    }
    
    func testUnreadCountEqualsOneWithTwoMessagesWhereOneIsAlreadyRead() {
        let unreadMessage = AppDataBuilder.makeMessage(read: false)
        let readMessage = AppDataBuilder.makeMessage(read: true)
        app.localPrivateMessages = [unreadMessage, readMessage]
        
        XCTAssertEqual(1, service.unreadMessageCount)
    }
    
}
