//
//  UserNotificationsScheduler.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 05/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import UserNotifications

struct UserNotificationsScheduler: NotificationScheduler {

    func scheduleReminderForEvent(identifier: EventIdentifier,
                                  scheduledFor date: Date,
                                  title: String,
                                  body: String,
                                  userInfo: [ApplicationNotificationKey: String]) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body

        var payload = [String: String]()
        for (key, value) in userInfo {
            payload[key.rawValue] = value
        }

        content.userInfo = payload

        let desiredComponents: Set<Calendar.Component> = Set([.year, .month, .day, .hour, .minute])
        let components = Calendar.current.dateComponents(desiredComponents, from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(identifier: identifier.rawValue, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Failed to add notification with error: \(error)")
            }
        }
    }

    func removeEventReminder(for identifier: EventIdentifier) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier.rawValue])
    }

}
