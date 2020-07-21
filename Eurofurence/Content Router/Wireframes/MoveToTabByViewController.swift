import UIKit

struct MoveToTabByViewController<T>: TabNavigator where T: UIViewController {
    
    var window: UIWindow

    func moveToTab() {
        guard let tabController = window.rootViewController as? UITabBarController else { return }
        guard let viewControllers = tabController.viewControllers else { return }
        
        for (idx, viewController) in viewControllers.enumerated() {
            moveToTab(for: viewController, in: tabController, viewControllerIndex: idx)
        }
    }
    
    private func moveToTab(
        for viewController: UIViewController,
        in tabController: UITabBarController,
        viewControllerIndex: Int
    ) {
        if viewController is T {
            tabController.selectedIndex = viewControllerIndex
        } else if let navigationController = viewController as? UINavigationController {
            navigateToViewController(
                containedIn: navigationController,
                tabController: tabController,
                navigationControllerIndexWithinTabBar: viewControllerIndex
            )
        } else if let splitViewController = viewController as? UISplitViewController,
            let masterNavigationController = splitViewController.viewControllers.first as? UINavigationController {
            navigateToViewController(
                containedIn: masterNavigationController,
                tabController: tabController,
                navigationControllerIndexWithinTabBar: viewControllerIndex
            )
        }
    }
    
    private func navigateToViewController(
        containedIn navigationController: UINavigationController,
        tabController: UITabBarController,
        navigationControllerIndexWithinTabBar: Int
    ) {
        if navigationController.viewControllers.contains(where: { $0 is T }) {
            tabController.selectedIndex = navigationControllerIndexWithinTabBar
        }
    }
    
}
