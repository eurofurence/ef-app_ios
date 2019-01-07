//
//  CapturingNotificationsService.swift
//  EurofurenceAppCoreTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class CapturingNotificationsService: NotificationsService {

    private(set) var capturedEventIdentifier: EventIdentifier?
    private(set) var capturedEventNotificationScheduledDate: Date?
    private(set) var capturedEventNotificationTitle: String?
    private(set) var capturedEventNotificationBody: String?
    private(set) var capturedEventNotificationUserInfo: [ApplicationNotificationKey: String] = [:]
    func scheduleReminderForEvent(identifier: EventIdentifier,
                                  scheduledFor date: Date,
                                  title: String,
                                  body: String,
                                  userInfo: [ApplicationNotificationKey: String]) {
        capturedEventIdentifier = identifier
        capturedEventNotificationScheduledDate = date
        capturedEventNotificationTitle = title
        capturedEventNotificationBody = body
        capturedEventNotificationUserInfo = userInfo
    }

    private(set) var capturedEventIdentifierToRemoveNotification: EventIdentifier?
    func removeEventReminder(for identifier: EventIdentifier) {
        capturedEventIdentifierToRemoveNotification = identifier
    }

}
