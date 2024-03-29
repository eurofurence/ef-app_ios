import ComponentBase
import UIKit

struct ResetNewsAfterLogout: NewsPresentation {
    
    var window: UIWindow
    
    func showNews() {
        guard let tabBarController = window.rootViewController as? UITabBarController else { return }
        guard let newsNavigationController = tabBarController
            .viewControllers?
            .compactMap({ $0 as? UISplitViewController })
            .compactMap({ $0.viewControllers.first as? UINavigationController })
            .first(where: { $0.viewControllers.contains(where: { $0 is CompositionalNewsViewController }) }) else {
                return
        }
        
        guard let newsControllerIndex = tabBarController
            .viewControllers?
            .compactMap({ $0 as? UISplitViewController })
            .compactMap({ $0.viewControllers.first as? UINavigationController })
            .firstIndex(of: newsNavigationController) else { return }
        
        guard let newsSplitViewController = tabBarController
            .viewControllers?[newsControllerIndex] as? UISplitViewController else { return }
        
        tabBarController.selectedIndex = newsControllerIndex
        newsNavigationController.popToRootViewController(animated: UIView.areAnimationsEnabled)
        
        let secondaryViewController = newsSplitViewController.viewControllers.last
        guard let detailNavigation = secondaryViewController as? UINavigationController else { return }
        
        let navigationStack = detailNavigation.viewControllers
        let nonMessageControllers = navigationStack.filter({ (viewController) in
            (viewController is MessageDetailViewController || viewController is MessagesViewController) == false
        })
        
        if nonMessageControllers.isEmpty {
            let placeholderController = NoContentPlaceholderViewController.fromStoryboard()
            let placeholderNavigationController = UINavigationController(rootViewController: placeholderController)
            newsSplitViewController.viewControllers = [newsNavigationController, placeholderNavigationController]
        } else {
            detailNavigation.setViewControllers(nonMessageControllers, animated: UIView.areAnimationsEnabled)
        }
    }
    
}
