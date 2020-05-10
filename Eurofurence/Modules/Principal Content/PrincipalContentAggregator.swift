import UIKit

public struct PrincipalContentAggregator: PrincipalContentModuleProviding {
    
    private let applicationModuleFactories: [ApplicationModuleFactory]
    
    public init(applicationModuleFactories: [ApplicationModuleFactory]) {
        self.applicationModuleFactories = applicationModuleFactories
    }
    
    public func makePrincipalContentModule() -> UIViewController {
        let applicationModules = applicationModuleFactories.map({ $0.makeApplicationModuleController() })
        let navigationControllers = applicationModules.map(NavigationController.init)
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
