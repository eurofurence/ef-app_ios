import UIKit

struct MoveToTabByViewController<T>: TabNavigator where T: UIViewController {
    
    var window: UIWindow
    
    func moveToTab() {
        guard let tabController = window.rootViewController as? UITabBarController else { return }
        guard let viewControllers = tabController.viewControllers else { return }
        
        for (idx, viewController) in viewControllers.enumerated() {
            if viewController is T {
                tabController.selectedIndex = idx
            } else if let navigationController = viewController as? UINavigationController {
                if navigationController.viewControllers.contains(where: { $0 is T }) {
                    tabController.selectedIndex = idx
                }
            }
        }
    }
    
}
