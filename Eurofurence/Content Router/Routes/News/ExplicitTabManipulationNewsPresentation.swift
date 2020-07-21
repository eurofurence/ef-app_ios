import UIKit

struct ExplicitTabManipulationNewsPresentation: NewsPresentation {
    
    var window: UIWindow
    
    func showNews() {
        guard let tabBarController = window.rootViewController as? UITabBarController else { return }
        guard let newsNavigationController = tabBarController
            .viewControllers?
            .compactMap({ $0 as? UISplitViewController })
            .compactMap({ $0.viewControllers.first as? UINavigationController })
            .first(where: { $0.viewControllers.contains(where: { $0 is NewsViewController }) }) else {
                return
        }
        
        guard let newsControllerIndex = tabBarController
            .viewControllers?
            .compactMap({ $0 as? UISplitViewController })
            .compactMap({ $0.viewControllers.first as? UINavigationController })
            .firstIndex(of: newsNavigationController) else { return }
        
        tabBarController.selectedIndex = newsControllerIndex
        newsNavigationController.popToRootViewController(animated: true)
    }
    
}
