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
		guard let rootViewController = window.rootViewController else { return }

		let notificationTitle = notification.alertTitle ?? ""
		let notificationBody = notification.alertBody ?? ""

		let announcement = Whisper.Announcement(title: notificationTitle, subtitle: notificationBody, image: UIImage.init(named: "AppIcon40x40"), duration: 10, action: { self.showLocalNotificationTarget(for: notification) })

		Whisper.show(shout: announcement, to: rootViewController)
	}

	func showLocalNotificationTarget(for notification: UILocalNotification) {
		guard let userInfo = notification.userInfo else { return }

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

	private func pushViewControllerOnTabBar(to identifier: String, viewController: UIViewController) {
		guard let rootViewController = window.rootViewController,
			let tabBarController = rootViewController.childViewControllers[0] as? UITabBarController,
			let navigationController = tabBarController.viewControllers?.first(where: { $0.restorationIdentifier == identifier }) as? UINavigationController else { return }

		tabBarController.selectedViewController = navigationController
		navigationController.pushViewController(viewController, animated: true)
	}
}
