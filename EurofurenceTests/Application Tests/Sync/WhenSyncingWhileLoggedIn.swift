//
//  WhenSyncingWhileLoggedIn.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenSyncingWhileLoggedIn: XCTestCase {
    
    func testSuccessfullyReloadingPrivateMessagesShouldNotifyObservers() {
        let expected = [Message].random.sorted()
        let context = ApplicationTestBuilder().build()
        context.loginSuccessfully()
        let observer = CapturingPrivateMessagesObserver()
        context.application.add(observer)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(.randomWithoutDeletions)
        context.privateMessagesAPI.simulateSuccessfulResponse(response: expected)
        
        XCTAssertEqual(expected, observer.observedMessages)
    }
    
}
