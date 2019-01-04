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

struct NotificationServiceFetchResultAdapter {

    private let notificationService: NotificationService

    init(notificationService: NotificationService) {
        self.notificationService = notificationService
    }

    func handleRemoteNotification(_ payload: [AnyHashable: Any],
                                  completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let castedPayloadKeysAndValues = payload.compactMap { (key, value) -> (String, String)? in
            guard let stringKey = key as? String, let stringValue = value as? String else { return nil }
            return (stringKey, stringValue)
        }

        let castedPayload = castedPayloadKeysAndValues.reduce(into: [String: String](), { $0[$1.0] = $1.1 })

        notificationService.handleNotification(payload: castedPayload) { (content) in
            switch content {
            case .successfulSync:
                completionHandler(.newData)

            case .failedSync:
                completionHandler(.failed)

            case .announcement(_):
                completionHandler(.newData)

            case .event(_):
                completionHandler(.noData)

            case .invalidatedAnnouncement:
                completionHandler(.noData)

            case .unknown:
                completionHandler(.noData)
            }
        }
    }

}

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
