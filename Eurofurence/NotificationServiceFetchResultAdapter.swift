//
//  NotificationServiceFetchResultAdapter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import UIKit

struct NotificationServiceFetchResultAdapter {

    private let notificationService: NotificationService

    init(notificationService: NotificationService) {
        self.notificationService = notificationService
    }

    func handleRemoteNotification(_ payload: [AnyHashable: Any],
                                  completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let castedPayloadKeysAndValues: [(String, String)] = payload.compactMap { (key, value) -> (String, String)? in
            guard let stringKey = key as? String, let stringValue = value as? String else { return nil }
            return (stringKey, stringValue)
        }

        let castedPayload: [String: String] = castedPayloadKeysAndValues.reduce(into: [String: String](), { $0[$1.0] = $1.1 })

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
