//
//  EurofurencePrivateMessagesServiceTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingPrivateMessageUnreadCountObserver: PrivateMessageUnreadCountObserver {
    
    private(set) var capturedUnreadMessagesCount: Int?
    func unreadPrivateMessagesCountDidChange(to unreadCount: Int) {
        capturedUnreadMessagesCount = unreadCount
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
    
    func testRefreshingPrivateMessagesWhenUserNotAuthenticatedShouldInvokeHandlerWithFailure() {
        var result: PrivateMessagesRefreshResult?
        service.refreshMessages { result = $0 }
        app.resolvePrivateMessagesFetch(.userNotAuthenticated)
        
        XCTAssertEqual(result, .failure)
    }
    
    func testFailedToLoadWhenRefreshingPrivateMessagesShouldInvokeHandlerWithFailure() {
        var result: PrivateMessagesRefreshResult?
        service.refreshMessages { result = $0 }
        app.resolvePrivateMessagesFetch(.failedToLoad)
        
        XCTAssertEqual(result, .failure)
    }
    
    func testLoadingPrivateMessagesSuccessfullyShouldProvideThemToTheCompletionHandler() {
        let messages = [AppDataBuilder.makeMessage()]
        var result: PrivateMessagesRefreshResult?
        service.refreshMessages { result = $0 }
        app.resolvePrivateMessagesFetch(.success(messages))
        
        XCTAssertEqual(result, .success(messages))
    }
    
    func testLocalMessagesProvideMessagesFromApplication() {
        let messages = [AppDataBuilder.makeMessage()]
        app.localPrivateMessages = messages
        
        XCTAssertEqual(messages, service.localMessages)
    }
    
    func testAddingUnreadPrivateMessageCountObserverTellsItTheNumberOfCurrentlyUnreadMessages() {
        let observer = CapturingPrivateMessageUnreadCountObserver()
        let messages = repeatElement(AppDataBuilder.makeMessage(read: false), count: Int(arc4random_uniform(10)))
        let expected = messages.count
        app.localPrivateMessages = Array(messages)
        service.add(observer)
        
        XCTAssertEqual(expected, observer.capturedUnreadMessagesCount)
    }
    
    func testAddingObserverThenRefreshProvidesMoreUnreadMessagesTellsObserver() {
        let observer = CapturingPrivateMessageUnreadCountObserver()
        service.add(observer)
        let messages = repeatElement(AppDataBuilder.makeMessage(read: false), count: Int(arc4random_uniform(10)))
        let expected = messages.count
        app.localPrivateMessages = Array(messages)
        service.refreshMessages(completionHandler: { (_) in })
        app.resolvePrivateMessagesFetch(.success([]))
        
        XCTAssertEqual(expected, observer.capturedUnreadMessagesCount)
    }
    
}
