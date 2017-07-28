//
//  RemoteNotificationSoundProviding.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol RemoteNotificationSoundProviding {

	var remoteNotificationSound: NotificationSound { get }

	func setRemoteNotificationSound(_ remoteNotificationSound: NotificationSound)

}

extension RemoteNotificationSoundProviding {
	func getRemoteNotificationSoundName() -> String? {
		return Self.getRemoteNotificationSoundName(for: remoteNotificationSound)
	}

	static func getRemoteNotificationSoundName(for notificationSound: NotificationSound) -> String? {
		switch notificationSound {
		case .None:
			return nil
		case .Classic:
			return "j1_generic.caf"
		case .Themed:
			return "j1_themed.caf"
		}
	}

	static func getRemoteNotificationDefaultSoundName() -> String {
		return "notification_default.caf"
	}
}
