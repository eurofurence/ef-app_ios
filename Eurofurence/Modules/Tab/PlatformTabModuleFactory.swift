import UIKit.UITabBarController
import UIKit.UIViewController

struct PlatformTabModuleFactory: TabModuleProviding {

    func makeTabModule(_ childModules: [UIViewController]) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = childModules

        return tabBarController
    }

}
