import UIKit

struct ExplicitTabManipulationNewsPresentation: NewsPresentation {
    
    var window: UIWindow
    
    func showNews() {
        guard let tabBarController = window.rootViewController as? UITabBarController else { return }
        guard let newsController = tabBarController
            .viewControllers?
            .compactMap({ $0 as? NewsViewController })
            .first else { return }
        
        guard let newsControllerIndex = tabBarController
            .viewControllers?
            .firstIndex(of: newsController) else { return }
        
        tabBarController.selectedIndex = newsControllerIndex
        newsController.navigationController?.popToRootViewController(animated: true)
    }
    
}
