//
//  WhenSyncingWhileLoggedIn.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenSyncingWhileLoggedIn: XCTestCase {

    func testObserversArePassedLoadedMessages() {
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

    func testAddingAnotherObserverIsPassedLoadedMessages() {
        let expected = [Message].random.sorted()
        let context = ApplicationTestBuilder().build()
        context.loginSuccessfully()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(.randomWithoutDeletions)
        context.privateMessagesAPI.simulateSuccessfulResponse(response: expected)
        let observer = CapturingPrivateMessagesObserver()
        context.application.add(observer)

        XCTAssertEqual(expected, observer.observedMessages)
    }

    func testTheSyncDoesNotFinishUntilMessagesHaveLoaded() {
        let context = ApplicationTestBuilder().build()
        context.loginSuccessfully()
        let observer = CapturingPrivateMessagesObserver()
        context.application.add(observer)
        var didFinishBeforeMessagesLoaded = false
        context.refreshLocalStore { _ in didFinishBeforeMessagesLoaded = true }
        context.syncAPI.simulateSuccessfulSync(.randomWithoutDeletions)

        XCTAssertFalse(didFinishBeforeMessagesLoaded)
    }

}
