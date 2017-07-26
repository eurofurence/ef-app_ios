//
//  NotificationRouter.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UserNotificationsUI

protocol NotificationRouter {
	func showLocalNotificationTarget(for notification: UILocalNotification, doWaitForDataStore: Bool)
	func showLocalNotification(for notification: UILocalNotification)

	func showRemoteNotificationTarget(for userInfo: [AnyHashable : Any], doWaitForDataStore: Bool)
	func showRemoteNotification(for userInfo: [AnyHashable : Any])
}
