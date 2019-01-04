//
//  NotificationServiceFetchResultAdapterTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class NotificationServiceFetchResultAdapterTests: XCTestCase {

    private func handleNotification(_ serviceResponse: NotificationContent) -> UIBackgroundFetchResult? {
        let notificationService = FakeApplicationNotificationHandling()
        let adapter = NotificationServiceFetchResultAdapter(notificationService: notificationService)
        let payload: [String : String] = ["Key": "Value"]
        notificationService.stub(serviceResponse, for: payload)
        var result: UIBackgroundFetchResult?
        adapter.handleRemoteNotification(payload, completionHandler: { result = $0 })

        return result
    }

    func testIndicatesNewDataForSuccessfulSyncNotifications() {
        XCTAssertEqual(UIBackgroundFetchResult.newData, handleNotification(.successfulSync))
    }

    func testIndicatesFailedForFailedSyncNotifications() {
        XCTAssertEqual(UIBackgroundFetchResult.failed, handleNotification(.failedSync))
    }

    func testIndicatesNewDataForAnnouncement() {
        XCTAssertEqual(UIBackgroundFetchResult.newData, handleNotification(.announcement(.random)))
    }

    func testIndicatesNoDataForEvent() {
        XCTAssertEqual(UIBackgroundFetchResult.noData, handleNotification(.event(.random)))
    }

    func testIndicatesNoDataForInvalidatedAnnouncements() {
        XCTAssertEqual(UIBackgroundFetchResult.noData, handleNotification(.invalidatedAnnouncement))
    }

    func testIndicatesNoDataForUnknownContent() {
        XCTAssertEqual(UIBackgroundFetchResult.noData, handleNotification(.unknown))
    }

}
