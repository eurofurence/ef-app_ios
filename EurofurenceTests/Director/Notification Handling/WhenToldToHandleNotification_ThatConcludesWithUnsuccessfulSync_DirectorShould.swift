//
//  WhenToldToHandleNotification_ThatConcludesWithUnsuccessfulSync_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenToldToHandleNotification_ThatConcludesWithUnsuccessfulSync_DirectorShould: XCTestCase {

    func testInvokeTheHandlerWithFailedResult() {
        let context = ApplicationDirectorTestBuilder().build()
        let payload = [String.random: String.random]
        context.notificationHandling.stub(.failedSync, for: payload)
        var result: UIBackgroundFetchResult?
        context.director.handleRemoteNotification(payload) { result = $0 }

        XCTAssertEqual(UIBackgroundFetchResult.failed, result)
    }

}
