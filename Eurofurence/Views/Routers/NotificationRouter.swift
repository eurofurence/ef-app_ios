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

enum NotificationUserInfoKey: String {
	/// See NotificationContentType for expected values
	case ContentType = "event"
	/// Id of event related to local notification
	case EventId = "event_id"
	case EventLastChangeDateTimeUtc = "event_lastchangedatetimeutc"
	/// Id of announcement related to remote notification
	case AnnouncementId = "announcement_id"
}

enum NotificationContentType: String {
	/// New announcement has been posted
	case Announcement = "announcement"
	/// Generic notification (currently only used for messages)
	case Notification = "notification"
	/// Backend data changed; should trigger silent background sync
	case Sync = "sync"
}
