import UIKit

public struct PrincipalContentAggregator: PrincipalContentModuleProviding {
    
    private let contentControllerFactories: [ContentControllerFactory]
    
    public init(contentControllerFactories: [ContentControllerFactory]) {
        self.contentControllerFactories = contentControllerFactories
    }
    
    public func makePrincipalContentModule() -> UIViewController {
        let contentControllers = contentControllerFactories.map({ $0.makeContentController() })
        let navigationControllers = contentControllers.map(NavigationController.init)
        let tabBarController = TabBarController()
        tabBarController.viewControllers = navigationControllers
        
        return tabBarController
    }
    
    private class NavigationController: UINavigationController {
        
        override func viewDidLoad() {
            super.viewDidLoad()    
            navigationBar.prefersLargeTitles = true
        }
        
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
