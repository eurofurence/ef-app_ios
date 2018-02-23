//
//  EurofurencePrivateMessagesServiceTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingPrivateMessageUnreadCountObserver: PrivateMessagesServiceObserver {
    
    private(set) var capturedUnreadMessagesCount: Int?
    func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int) {
        capturedUnreadMessagesCount = unreadCount
    }
    
    private(set) var loadedMessages: [Message] = []
    private(set) var serviceDidLoadEmptyMessagesArray = false
    func privateMessagesServiceDidFinishRefreshingMessages(_ messages: [Message]) {
        loadedMessages = messages
        serviceDidLoadEmptyMessagesArray = messages.isEmpty
    }
    
    private(set) var toldLoadFailed = false
    func privateMessagesServiceDidFailToLoadMessages() {
        toldLoadFailed = true
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
        let observer = CapturingPrivateMessageUnreadCountObserver()
        service.add(observer)
        let unreadMessageCount = Int.random(upperLimit: 10)
        let messages = (0..<unreadMessageCount).map({ _ in AppDataBuilder.makeMessage(read: false) })
        app.localPrivateMessages = messages
        service.refreshMessages()
        app.resolvePrivateMessagesFetch(.success(messages))
        
        XCTAssertEqual(unreadMessageCount, observer.capturedUnreadMessagesCount)
    }
    
    func testUnreadCountEqualsOneWithTwoMessagesWhereOneIsAlreadyRead() {
        let observer = CapturingPrivateMessageUnreadCountObserver()
        service.add(observer)
        let unreadMessage = AppDataBuilder.makeMessage(read: false)
        let readMessage = AppDataBuilder.makeMessage(read: true)
        app.localPrivateMessages = [unreadMessage, readMessage]
        service.refreshMessages()
        app.resolvePrivateMessagesFetch(.success([unreadMessage, readMessage]))
        
        XCTAssertEqual(1, observer.capturedUnreadMessagesCount)
    }
    
    func testRefreshingPrivateMessagesWhenUserNotAuthenticatedShouldTellObserverLoadFailed() {
        let observer = CapturingPrivateMessageUnreadCountObserver()
        service.add(observer)
        service.refreshMessages()
        app.resolvePrivateMessagesFetch(.userNotAuthenticated)
        
        XCTAssertTrue(observer.toldLoadFailed)
    }
    
    func testFailedToLoadWhenRefreshingPrivateMessagesShouldTellObserverLoadFailed() {
        let observer = CapturingPrivateMessageUnreadCountObserver()
        service.add(observer)
        service.refreshMessages()
        app.resolvePrivateMessagesFetch(.failedToLoad)
        
        XCTAssertTrue(observer.toldLoadFailed)
    }
    
    func testLoadingPrivateMessagesSuccessfullyShouldTellObserverLoadSucceeded() {
        let messages = [AppDataBuilder.makeMessage()]
        let observer = CapturingPrivateMessageUnreadCountObserver()
        service.add(observer)
        service.refreshMessages()
        app.resolvePrivateMessagesFetch(.success(messages))
        
        XCTAssertEqual(messages, observer.loadedMessages)
    }
    
    func testLoadingMessagesEmitsAppLocalMessagesWhileLoading() {
        let observer = CapturingPrivateMessageUnreadCountObserver()
        service.add(observer)
        let messages = [AppDataBuilder.makeMessage()]
        app.localPrivateMessages = messages
        service.refreshMessages()
        
        XCTAssertEqual(messages, observer.loadedMessages)
    }
    
    func testLoadingMessagesWhenAppDoesNotHaveLocalMessagesDoesNotEmitEmptyMessagesArrayWhileLoading() {
        let observer = CapturingPrivateMessageUnreadCountObserver()
        service.add(observer)
        app.localPrivateMessages = []
        service.refreshMessages()
        
        XCTAssertFalse(observer.serviceDidLoadEmptyMessagesArray)
    }
    
    func testAddingUnreadPrivateMessageCountObserverTellsItTheNumberOfCurrentlyUnreadMessages() {
        let observer = CapturingPrivateMessageUnreadCountObserver()
        let messages = repeatElement(AppDataBuilder.makeMessage(read: false), count: .random(upperLimit: 10))
        let expected = messages.count
        app.localPrivateMessages = Array(messages)
        service.add(observer)
        
        XCTAssertEqual(expected, observer.capturedUnreadMessagesCount)
    }
    
    func testAddingObserverThenRefreshProvidesMoreUnreadMessagesTellsObserver() {
        let observer = CapturingPrivateMessageUnreadCountObserver()
        service.add(observer)
        let messages = repeatElement(AppDataBuilder.makeMessage(read: false), count: .random(upperLimit: 10))
        let expected = messages.count
        app.localPrivateMessages = Array(messages)
        service.refreshMessages()
        app.resolvePrivateMessagesFetch(.success([]))
        
        XCTAssertEqual(expected, observer.capturedUnreadMessagesCount)
    }
    
}
