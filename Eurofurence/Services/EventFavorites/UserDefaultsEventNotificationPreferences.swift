//
//  UserDefaultsEventNotificationPreferences.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class UserDefaultsEventNotificationPreferences: EventNotificationPreferences {
	static let notificationAheadIntervalKey = "EventNotificationPreferences.notificationAheadInterval"
	static let notificationSound = "EventNotificationPreferences.notificationSound"
	static let notificationsEnabledKey = "EventNotificationPreferences.notificationsEnabled"
	static let instance = UserDefaultsEventNotificationPreferences(userDefaults: UserDefaults.standard)

	var notificationAheadInterval: TimeInterval {
		return userDefaults.double(forKey: UserDefaultsEventNotificationPreferences.notificationAheadIntervalKey)
	}

	var notificationsEnabled: Bool {
		return userDefaults.bool(forKey: UserDefaultsEventNotificationPreferences.notificationsEnabledKey)
	}

	var notificationSound: NotificationSound {
		return NotificationSound(rawValue: userDefaults.integer(forKey: UserDefaultsEventNotificationPreferences.notificationSound)) ?? NotificationSound.None
	}

	var signal: Signal<(Bool, TimeInterval), NoError> {
		return _signal
	}

	private let (_signal, observer) = Signal<(Bool, TimeInterval), NoError>.pipe()
	private let userDefaults: UserDefaults

	init(userDefaults: UserDefaults) {
		self.userDefaults = userDefaults
		userDefaults.register(defaults: [
			UserDefaultsEventNotificationPreferences.notificationAheadIntervalKey: 60.0 * 60.0,
			UserDefaultsEventNotificationPreferences.notificationSound: NotificationSound.Themed.rawValue,
			UserDefaultsEventNotificationPreferences.notificationsEnabledKey: true
			])
	}

	func setNotificationAheadInterval(_ interval: TimeInterval) {
		userDefaults.set(interval, forKey: UserDefaultsEventNotificationPreferences.notificationAheadIntervalKey)
		notify()
	}

	func setNotificationSound(_ notificationSound: NotificationSound) {
		userDefaults.set(notificationSound.rawValue, forKey: UserDefaultsEventNotificationPreferences.notificationSound)
		notify()
	}

	func setNotificationsEnabled(_ enabled: Bool) {
		userDefaults.set(enabled, forKey: UserDefaultsEventNotificationPreferences.notificationsEnabledKey)
		notify()
	}

	private func notify() {
		observer.send(value: (notificationsEnabled, notificationAheadInterval))
	}
}
