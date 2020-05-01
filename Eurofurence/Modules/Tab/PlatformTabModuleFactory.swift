import UIKit.UITabBarController
import UIKit.UIViewController

struct PlatformTabModuleFactory: TabModuleProviding {

    func makeTabModule(_ childModules: [UIViewController]) -> UITabBarController {
        let tabBarController = TabBarController()
        tabBarController.viewControllers = childModules

        return tabBarController
    }
    
    private class TabBarController: UITabBarController {
        
        override func show(_ vc: UIViewController, sender: Any?) {
            selectedViewController?.show(vc, sender: sender)
        }
        
        override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
            show(vc, sender: sender)
        }
        
    }

}
