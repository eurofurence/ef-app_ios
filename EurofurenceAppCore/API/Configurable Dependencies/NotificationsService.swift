//
//  NotificationsService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 05/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public protocol NotificationsService {

    func scheduleReminderForEvent(identifier: Event2.Identifier,
                                  scheduledFor date: Date,
                                  title: String,
                                  body: String,
                                  userInfo: [ApplicationNotificationKey: String])
    func removeEventReminder(for identifier: Event2.Identifier)

}

public enum ApplicationNotificationKey: String, Codable {
    case notificationContentKind
    case notificationContentIdentifier
}

public enum ApplicationNotificationContentKind: String, Codable {
    case event
}
