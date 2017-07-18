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
	var notificationsEnabled: Bool { get }
	var signal: Signal<(Bool, TimeInterval), NoError> { get }

	func setNotificationAheadInterval(_ interval: TimeInterval)
	func setNotificationsEnabled(_ enabled: Bool)
}
