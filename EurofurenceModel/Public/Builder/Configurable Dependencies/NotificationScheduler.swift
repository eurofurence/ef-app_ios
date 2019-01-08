//
//  NotificationScheduler.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 05/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public protocol NotificationScheduler {

    func scheduleReminderForEvent(identifier: EventIdentifier,
                                  scheduledFor date: Date,
                                  title: String,
                                  body: String,
                                  userInfo: [ApplicationNotificationKey: String])
    func removeEventReminder(for identifier: EventIdentifier)

}

public enum ApplicationNotificationKey: String, Codable {
    case notificationContentKind
    case notificationContentIdentifier
}

public enum ApplicationNotificationContentKind: String, Codable {
    case event
}
