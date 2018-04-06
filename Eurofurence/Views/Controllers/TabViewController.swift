//
//  TabViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController, UITabBarControllerDelegate {
	static let fixedViewControllers: [String] = ["NewsNavigation", "SettingsNavigation", "AboutNavigation"]

	let tabBarOrderProviding: TabBarOrderProviding = UserDefaultsTabBarOrderProvider(userDefaults: UserDefaults.standard)
    lazy var progressView: UIProgressView = UIProgressView(progressViewStyle: .bar)

    override func viewDidLoad() {
        super.viewDidLoad()

		restoreTabBarOrder()

		customizableViewControllers = viewControllers?.filter({ !TabViewController.fixedViewControllers.contains($0.restorationIdentifier ?? "") })

        progressView.alpha = 0
        progressView.isHidden = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)

        let views = ["Progress": progressView, "TabBar": tabBar] as [String: UIView]
        let visualFormats = ["H:|[Progress]|", "V:[Progress][TabBar]"]
        let constraints = visualFormats.map({ NSLayoutConstraint.constraints(withVisualFormat: $0,
                                                                             options: [.alignAllCenterX],
                                                                             metrics: nil,
                                                                             views: views) })
        view.addConstraints(constraints.reduce([], { $0 + $1 }))

        let refreshingDelegate = ProgressViewRefreshDelegate(progressView: progressView)
        DataStoreRefreshController.shared.add(refreshingDelegate)
		DataStoreRefreshController.shared.add(StatusWhistleRefreshDelegate())
    }

	override func tabBar(_ tabBar: UITabBar, didEndCustomizing items: [UITabBarItem], changed: Bool) {
		var viewControllerOrder: [String] = []
		viewControllers?.forEach { viewController in
			if let vcIdentifier = viewController.restorationIdentifier {
				viewControllerOrder.append(vcIdentifier)
			}
		}
		tabBarOrderProviding.setTabBarOrder(viewControllerOrder)
	}

	private func restoreTabBarOrder() {
		let tabBarOrder = tabBarOrderProviding.tabBarOrder
		guard let viewControllers = viewControllers,
			tabBarOrder.count == viewControllers.count else { return }

		var viewControllersByIdentifier: [String: UIViewController] = [:]
		for viewController in viewControllers {
			if let vcIdentifier = viewController.restorationIdentifier,
					tabBarOrder.contains(vcIdentifier) {
				viewControllersByIdentifier[vcIdentifier] = viewController
			} else {
				// Something in the tab bar composition changed; stop restoring.
				return
			}
		}

		var restoredViewControllers: [UIViewController] = []

		for vcIdentifier in tabBarOrder {
			restoredViewControllers.append(viewControllersByIdentifier[vcIdentifier]!)
		}

		self.viewControllers = restoredViewControllers
	}
}
