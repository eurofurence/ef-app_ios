//
//  CapturingNotificationsService.swift
//  EurofurenceAppCoreTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

class CapturingNotificationsService: NotificationsService {
    
    private(set) var capturedEventIdentifier: Event2.Identifier?
    private(set) var capturedEventNotificationScheduledDate: Date?
    private(set) var capturedEventNotificationTitle: String?
    private(set) var capturedEventNotificationBody: String?
    private(set) var capturedEventNotificationUserInfo: [ApplicationNotificationKey : String] = [:]
    func scheduleReminderForEvent(identifier: Event2.Identifier,
                                  scheduledFor date: Date,
                                  title: String,
                                  body: String,
                                  userInfo: [ApplicationNotificationKey : String]) {
        capturedEventIdentifier = identifier
        capturedEventNotificationScheduledDate = date
        capturedEventNotificationTitle = title
        capturedEventNotificationBody = body
        capturedEventNotificationUserInfo = userInfo
    }
    
    private(set) var capturedEventIdentifierToRemoveNotification: Event2.Identifier?
    func removeEventReminder(for identifier: Event2.Identifier) {
        capturedEventIdentifierToRemoveNotification = identifier
    }
    
}
