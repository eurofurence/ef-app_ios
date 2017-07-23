//
//  NotificationRouter.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UserNotificationsUI

protocol NotificationRouter {
	func showLocalNotificationTarget(for notification: UILocalNotification)
	func showLocalNotification(for notification: UILocalNotification)
}
