//
//  StoryboardTargetRouter.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

class StoryboardTargetRouter: TargetRouter {
	private var window: UIWindow
	private let storyboard = UIStoryboard(name: "Main", bundle: nil)

	init(window: UIWindow) {
		self.window = window
	}

	func show(target: RoutingTarget) {
		guard let tabBarController = getTabBarController(),
			let navigationController = getNavigationController(for: target.navigationControllerIdentifier, on: tabBarController)
			else { return }

		let viewController = storyboard.instantiateViewController(withIdentifier: target.viewControllerIdentifier)
		target.payload?.forEach({ (key, value) in
			viewController.setValue(value, forKey: key)
		})

		if !navigationController.isBeingPresented {
			tabBarController.selectedViewController = navigationController
		}

		if let identifier = viewController.restorationIdentifier,
				identifier != navigationController.viewControllers.last?.restorationIdentifier {
			navigationController.pushViewController(viewController, animated: true)
		}
	}

	private func getTabBarController() -> UITabBarController? {
		guard let rootViewController = window.rootViewController else {
			return nil
		}
		return rootViewController.childViewControllers[0] as? UITabBarController
	}

	private func getNavigationController(for navigationControllerIdentifier: String,
	                                     on tabBarController: UITabBarController) -> UINavigationController? {
		return tabBarController.viewControllers?.first(where: { $0.restorationIdentifier == navigationControllerIdentifier }) as? UINavigationController
	}
}
