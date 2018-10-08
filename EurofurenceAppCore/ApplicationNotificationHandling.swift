//
//  ApplicationNotificationHandling.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public enum ApplicationPushActionResult: Equatable {
    case successfulSync
    case failedSync
    case unknown
    case announcement(Announcement2.Identifier)
    case invalidatedAnnouncement
    case event(Event2.Identifier)
}

public protocol ApplicationNotificationHandling {

    func handleRemoteNotification(payload: [String: String], completionHandler: @escaping (ApplicationPushActionResult) -> Void)

}
