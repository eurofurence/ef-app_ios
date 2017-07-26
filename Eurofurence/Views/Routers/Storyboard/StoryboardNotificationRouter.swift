//
//  StoryboardNotificationRouter.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UIKit
import Whisper

struct StoryboardNotificationRouter: NotificationRouter {
	private let window: UIWindow
	private let dataContext: DataContextProtocol = try! ContextResolver.container.resolve()
	private let storyboard = UIStoryboard(name: "Main", bundle: nil)

	init(window: UIWindow) {
		self.window = window
	}

	func showLocalNotification(for notification: UILocalNotification) {

		let notificationTitle = notification.alertTitle ?? ""
		let notificationBody = notification.alertBody ?? ""

		showNotification(title: notificationTitle, subtitle: notificationBody,
		                 action: { self.showLocalNotificationTarget(for: notification) })
	}

	func showLocalNotificationTarget(for notification: UILocalNotification) {
		guard let userInfo = notification.userInfo else { return }

		showRemoteNotification(for: userInfo)
	}

	func showRemoteNotification(for userInfo: [AnyHashable : Any]) {
		guard let event = userInfo["Event"] as? String else { return }

		switch event {
		case "Announcement":
			let aps = userInfo["aps"] as? [AnyHashable : Any]
			let alert = aps?["alert"] as? [AnyHashable : Any]
			let title = alert?["title"] as? String ?? aps?["alert"] as? String ?? "New Announcement"
			let body = alert?["body"] as? String ?? "Please open the app to view this announcement."
			showNotification(title: title, subtitle: body, action: { self.showRemoteNotificationTarget(for: userInfo) })
		default:
			return
		}
	}

	func showRemoteNotificationTarget(for userInfo: [AnyHashable : Any]) {
		let viewController: UIViewController
		let targetIdentifier: String
		if let eventId = userInfo["Event.Id"] as? String {
			let eventViewController = storyboard.instantiateViewController(withIdentifier: "EventDetailView") as! EventViewController
			eventViewController.event = dataContext.Events.value.first(where: { $0.Id == eventId })
			viewController = eventViewController
			targetIdentifier = "NewsNavigation"
		} else {
			return
		}

		pushViewControllerOnTabBar(to: targetIdentifier, viewController: viewController)
	}

	private func showNotification(title: String, subtitle: String, action: (() -> Void)?) {
		guard let rootViewController = window.rootViewController else { return }

		let announcement = Whisper.Announcement(title: title, subtitle: subtitle,
		                                        image: UIImage.init(named: "AppIcon40x40"),
		                                        duration: 10,
		                                        action: action)
		Whisper.show(shout: announcement, to: rootViewController)
	}

	private func pushViewControllerOnTabBar(to identifier: String, viewController: UIViewController) {
		guard let rootViewController = window.rootViewController,
			let tabBarController = rootViewController.childViewControllers[0] as? UITabBarController,
			let navigationController = tabBarController.viewControllers?.first(where: { $0.restorationIdentifier == identifier }) as? UINavigationController else { return }

		tabBarController.selectedViewController = navigationController
		navigationController.pushViewController(viewController, animated: true)
	}
}
