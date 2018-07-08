//
//  ApplicationNotificationHandling.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

enum ApplicationPushActionResult: Equatable {
    case successfulSync
    case failedSync
}

protocol ApplicationNotificationHandling {

    func handleRemoteNotification(payload: [String: String], completionHandler: @escaping (ApplicationPushActionResult) -> Void)

}
