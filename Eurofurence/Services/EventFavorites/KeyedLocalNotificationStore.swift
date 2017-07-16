//
//  KeyedLocalNotificationStore.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UserNotificationsUI

struct KeyedLocalNotificationStore: LocalNotificationStore {
	private static let filePrefix = "LocalNotificationStore"
	private let baseDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

	let name: String

	init(name: String) {
		self.name = name
	}

	func loadLocalNotifications() -> [UILocalNotification] {
		let filePath = baseDirectory.appendingPathComponent(KeyedLocalNotificationStore.filePrefix + name, isDirectory: false)
		if let notifications = NSKeyedUnarchiver.unarchiveObject(withFile: filePath.path) as? [UILocalNotification] {
			return notifications
		} else {
			return []
		}
	}

	func storeLocalNotifications(_ notifications: [UILocalNotification]) {
		var filePath = baseDirectory.appendingPathComponent(KeyedLocalNotificationStore.filePrefix + name, isDirectory: false)
		let storeSuccess = NSKeyedArchiver.archiveRootObject(notifications, toFile: filePath.path)
		if storeSuccess {
			do {
				try filePath.setExcludedFromBackup(true)
			} catch {
				print("Failed to exclude LocalNotificationStore at \(filePath.path) from backup!")
			}
		}
	}
}
