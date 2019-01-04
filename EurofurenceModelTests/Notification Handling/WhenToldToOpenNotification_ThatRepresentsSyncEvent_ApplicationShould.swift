//
//  WhenToldToOpenNotification_ThatRepresentsSyncEvent_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenToldToOpenNotification_ThatRepresentsSyncEvent_ApplicationShould: XCTestCase {

    var context: ApplicationTestBuilder.Context!

    override func setUp() {
        super.setUp()

        context = ApplicationTestBuilder().build()
    }

    private func simulateSyncPushNotification(_ handler: @escaping (NotificationContent) -> Void) {
        let payload: [String: String] = ["event": "sync"]
        context.application.handleNotification(payload: payload, completionHandler: handler)
    }

    func testRefreshTheLocalStore() {
        simulateSyncPushNotification { (_) in }
        XCTAssertTrue(context.syncAPI.didBeginSync)
    }

    func testProvideSyncSuccessResultWhenDownloadSucceeds() {
        var result: NotificationContent?
        simulateSyncPushNotification { result = $0 }
        context.syncAPI.simulateSuccessfulSync(.randomWithoutDeletions)

        XCTAssertEqual(.successfulSync, result)
    }

    func testProideSyncFailedResponseWhenDownloadFails() {
        var result: NotificationContent?
        simulateSyncPushNotification { result = $0 }
        context.syncAPI.simulateUnsuccessfulSync()

        XCTAssertEqual(.failedSync, result)
    }

}
