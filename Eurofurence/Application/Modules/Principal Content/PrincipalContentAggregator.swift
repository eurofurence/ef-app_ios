import UIKit

public struct PrincipalContentAggregator: PrincipalContentModuleProviding {
    
    private let applicationModuleFactories: [ApplicationModuleFactory]
    
    public init(applicationModuleFactories: [ApplicationModuleFactory]) {
        self.applicationModuleFactories = applicationModuleFactories
    }
    
    public func makePrincipalContentModule() -> UIViewController {
        let applicationModules = applicationModuleFactories.map({ $0.makeApplicationModuleController() })
        let navigationControllers = applicationModules.map(NavigationController.init)
        let noContentStoryboard = UIStoryboard(name: "NoContentPlaceholderViewController", bundle: nil)
        let splitViewControllers = navigationControllers.map { (navigationController) -> UISplitViewController in
            let splitViewController = SplitViewController()
            let noContentPlaceholder = noContentStoryboard.instantiateInitialViewController().unsafelyUnwrapped
            splitViewController.viewControllers = [navigationController, noContentPlaceholder]
            
            return splitViewController
        }
        
        let tabBarController = TabBarController()
        tabBarController.viewControllers = splitViewControllers
        
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
            selectedViewController?.showDetailViewController(vc, sender: sender)
        }
        
    }
    
    private class SplitViewController: UISplitViewController {
        
        override func show(_ vc: UIViewController, sender: Any?) {
            if let masterNavigation = viewControllers.first as? UINavigationController {
                masterNavigation.pushViewController(vc, animated: UIView.areAnimationsEnabled)
            } else {
                super.show(vc, sender: sender)
            }
        }
        
    }
    
}
