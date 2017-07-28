//
//  EventNotificationPreferences.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol EventNotificationPreferences {
	var notificationAheadInterval: TimeInterval { get }
	var notificationSound: NotificationSound { get }
	var notificationsEnabled: Bool { get }
	var signal: Signal<(Bool, TimeInterval), NoError> { get }

	func setNotificationAheadInterval(_ interval: TimeInterval)
	func setNotificationSound(_ notificationSound: NotificationSound)
	func setNotificationsEnabled(_ enabled: Bool)
}

extension EventNotificationPreferences {
	func getNotificationSoundName() -> String? {
		return Self.getNotificationSoundName(for: notificationSound)
	}

	static func getNotificationSoundName(for notificationSound: NotificationSound) -> String? {
		switch notificationSound {
		case .None:
			return nil
		case .Classic:
			return "j2_generic.caf"
		case .Themed:
			return "j2_themed.caf"
		}
	}
}
