//
//  LocalNotificationStore.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UserNotificationsUI

protocol LocalNotificationStore {
	var name: String { get }

	init(name: String)
	func loadLocalNotifications() -> [UILocalNotification]
	func storeLocalNotifications(_ notifications: [UILocalNotification])
}
