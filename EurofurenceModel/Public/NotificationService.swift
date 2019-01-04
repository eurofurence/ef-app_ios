//
//  NotificationService.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 28/12/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public enum NotificationContent: Equatable {
    case successfulSync
    case failedSync
    case unknown
    case announcement(Announcement.Identifier)
    case invalidatedAnnouncement
    case event(Event.Identifier)
}

public protocol NotificationService {
    
    func handleNotification(payload: [String: String], completionHandler: @escaping (NotificationContent) -> Void)
    
}
