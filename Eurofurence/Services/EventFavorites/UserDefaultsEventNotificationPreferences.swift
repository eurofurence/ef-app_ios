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
	static let notificationsEnabledKey = "EventNotificationPreferences.notificationsEnabled"
	static let instance = UserDefaultsEventNotificationPreferences(userDefaults: UserDefaults.standard)

	var notificationAheadInterval: TimeInterval {
		return _notificationAheadInterval
	}

	var notificationsEnabled: Bool {
		return _notificationsEnabled
	}

	var signal: Signal<(Bool, TimeInterval), NoError> {
		return _signal
	}

	private var _notificationAheadInterval = TimeInterval(0.0)
	private var _notificationsEnabled = false
	private let (_signal, observer) = Signal<(Bool, TimeInterval), NoError>.pipe()
	private let userDefaults: UserDefaults

	init(userDefaults: UserDefaults) {
		self.userDefaults = userDefaults
		userDefaults.register(defaults: [
			UserDefaultsEventNotificationPreferences.notificationAheadIntervalKey: 60.0 * 60.0,
			UserDefaultsEventNotificationPreferences.notificationsEnabledKey: true
			])
		_notificationAheadInterval = userDefaults.double(forKey: UserDefaultsEventNotificationPreferences.notificationAheadIntervalKey)
		_notificationsEnabled = userDefaults.bool(forKey: UserDefaultsEventNotificationPreferences.notificationsEnabledKey)
	}

	func setNotificationAheadInterval(_ interval: TimeInterval) {
		userDefaults.set(interval, forKey: UserDefaultsEventNotificationPreferences.notificationAheadIntervalKey)
		_notificationAheadInterval = interval
		notify()
	}

	func setNotificationsEnabled(_ enabled: Bool) {
		userDefaults.set(enabled, forKey: UserDefaultsEventNotificationPreferences.notificationsEnabledKey)
		_notificationsEnabled = enabled
		notify()
	}

	private func notify() {
		observer.send(value: (notificationsEnabled, notificationAheadInterval))
	}
}
