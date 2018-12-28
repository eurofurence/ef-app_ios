//
//  ApplicationNotificationHandling.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 28/12/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public enum ApplicationPushActionResult: Equatable {
    case successfulSync
    case failedSync
    case unknown
    case announcement(Announcement.Identifier)
    case invalidatedAnnouncement
    case event(Event.Identifier)
}

public protocol ApplicationNotificationHandling {
    
    func handleRemoteNotification(payload: [String: String], completionHandler: @escaping (ApplicationPushActionResult) -> Void)
    
}
