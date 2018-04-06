//
//  StoryboardNotificationRouter.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UIKit
import Whisper
import AudioToolbox

struct StoryboardNotificationRouter: NotificationRouter {
	private let window: UIWindow
	private let targetRouter: TargetRouter
	private let dataContext: DataContextProtocol = try! ContextResolver.container.resolve()
	private let storyboard = UIStoryboard(name: "Main", bundle: nil)
	private let remoteNotificationSoundProviding = UserDefaultsRemoteNotificationSoundProvider(userDefaults: UserDefaults.standard)

	init(window: UIWindow, targetRouter: TargetRouter) {
		self.window = window
		self.targetRouter = targetRouter
	}

	func showLocalNotification(for notification: UILocalNotification) {
		let notificationTitle = notification.alertTitle ?? ""
		let notificationBody = notification.alertBody ?? ""

		showNotification(title: notificationTitle, subtitle: notificationBody,
		                 soundName: notification.soundName,
		                 action: { self.showLocalNotificationTarget(for: notification) })
	}

	func showLocalNotificationTarget(for notification: UILocalNotification, doWaitForDataStore: Bool = false) {
		guard let userInfo = notification.userInfo else { return }

		showNotificationTarget(for: userInfo, doWaitForDataStore: doWaitForDataStore)
	}

	func showRemoteNotification(for userInfo: [AnyHashable: Any]) {
		guard let contentTypeString = userInfo[NotificationUserInfoKey.ContentType.rawValue] as? String,
			let contentType = NotificationContentType(rawValue: contentTypeString) else { return }

		let aps = userInfo["aps"] as? [AnyHashable: Any]
		let alert = aps?["alert"] as? [AnyHashable: Any]
		let title = alert?["title"] as? String ?? aps?["alert"] as? String
		let body = alert?["body"] as? String
		switch contentType {
		case .Announcement:
			showNotification(title: title ?? "New Announcement",
			                 subtitle: body ?? "Please open the app to view this announcement.",
			                 soundName: remoteNotificationSoundProviding.getRemoteNotificationSoundName(),
			                 action: { self.showRemoteNotificationTarget(for: userInfo) })
		case .Notification:
			showNotification(title: title ?? "New Private Message",
			                 subtitle: body ?? "Please open the app to view this message.",
			                 soundName: remoteNotificationSoundProviding.getRemoteNotificationSoundName(),
			                 action: { self.showRemoteNotificationTarget(for: userInfo) })
		default:
			return
		}
	}

	func showRemoteNotificationTarget(for userInfo: [AnyHashable: Any], doWaitForDataStore: Bool = false) {
		showNotificationTarget(for: userInfo, doWaitForDataStore: doWaitForDataStore)
	}

	private func showNotificationTarget(for userInfo: [AnyHashable: Any], doWaitForDataStore: Bool = false) {
		guard let contentTypeString = userInfo[NotificationUserInfoKey.ContentType.rawValue] as? String,
				let contentType = NotificationContentType(rawValue: contentTypeString) else {
			return
		}

		var notificationRoutingTarget: RoutingTarget?
		var lazyPayload: [String : ()->Any?]?

		switch contentType {
		case .Announcement:
			if let announcementId = userInfo[NotificationUserInfoKey.AnnouncementId.rawValue] as? String {
				var payload: [String: Any]?
				if let announcement = dataContext.Announcements.value.first(where: { $0.Id == announcementId }) {
					payload = ["announcement": announcement]
				} else {
					lazyPayload = ["announcement": { self.dataContext.Announcements.value.first(where: { $0.Id == announcementId }) }]
				}
				notificationRoutingTarget = RoutingTarget(target: "AnnouncementDetailView",
				                              on: "NewsNavigation",
				                              payload: payload)
			}
		case .EventFavorite:
			if let eventId = userInfo[NotificationUserInfoKey.EventId.rawValue] as? String {
				var payload: [String: Any]?
				if let event = dataContext.Events.value.first(where: { $0.Id == eventId }) {
					payload = ["event": event]
				} else {
					lazyPayload = ["event": { self.dataContext.Events.value.first(where: { $0.Id == eventId }) }]
				}
				notificationRoutingTarget = RoutingTarget(target: "EventDetailView",
				                              on: "NewsNavigation",
				                              payload: payload)
			}
		case .Notification:
			notificationRoutingTarget = RoutingTarget(target: "MessagesTableView",
				                              on: "NewsNavigation")
		default:
			break
		}

		guard let routingTarget = notificationRoutingTarget else { return }

		if doWaitForDataStore {
			let postDataStoreRoutingDelegate = PostDataStoreRoutingDelegate(
				targetRouter: targetRouter, target: routingTarget, lazyPayload: lazyPayload)
			DataStoreLoadController.shared.add(postDataStoreRoutingDelegate)
			DataStoreRefreshController.shared.add(postDataStoreRoutingDelegate)
		} else {
			targetRouter.show(target: routingTarget)
		}
	}

	private func showNotification(title: String, subtitle: String, soundName: String? = nil, action: (() -> Void)? = nil) {
		guard let rootViewController = window.rootViewController else { return }
		let announcement = Whisper.Announcement(title: title, subtitle: subtitle,
		                                        image: UIImage.init(named: "AppIcon40x40"),
		                                        duration: 10,
		                                        action: action)
		Whisper.show(shout: announcement, to: rootViewController)
		NotificationSoundPlayer.shared.playSound(for: soundName)
	}

	private func pushViewControllerOnTabBar(to identifier: String, viewController: UIViewController) {
		guard let rootViewController = window.rootViewController,
			let tabBarController = rootViewController.childViewControllers[0] as? UITabBarController,
			let navigationController = tabBarController.viewControllers?.first(where: { $0.restorationIdentifier == identifier }) as? UINavigationController else { return }

		tabBarController.selectedViewController = navigationController
		navigationController.pushViewController(viewController, animated: true)
	}
}
