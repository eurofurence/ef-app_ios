import UIKit

public struct PrincipalContentAggregator: PrincipalContentModuleProviding {
    
    private let applicationModuleFactories: [ApplicationModuleFactory]
    
    public init(applicationModuleFactories: [ApplicationModuleFactory]) {
        self.applicationModuleFactories = applicationModuleFactories
    }
    
    public func makePrincipalContentModule() -> UIViewController {
        let applicationModules = applicationModuleFactories.map({ $0.makeApplicationModuleController() })
        let navigationControllers = applicationModules.map(NavigationController.init)
        let splitViewControllers = navigationControllers.map { (navigationController) -> UISplitViewController in
            let splitViewController = SplitViewController()
            let noContentPlaceholder = NoContentPlaceholderViewController.fromStoryboard()
            splitViewController.viewControllers = [navigationController, noContentPlaceholder]
            splitViewController.tabBarItem = navigationController.tabBarItem
            
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
    
    private class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            delegate = self
            extendedLayoutIncludesOpaqueBars = true
            preferredDisplayMode = .allVisible
        }
        
        override func show(_ vc: UIViewController, sender: Any?) {
            if let masterNavigation = viewControllers.first as? UINavigationController {
                masterNavigation.pushViewController(vc, animated: UIView.areAnimationsEnabled)
            } else {
                super.show(vc, sender: sender)
            }
        }
        
        override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
            if let detailNavigationController = viewControllers.last as? UINavigationController {
                var context = (sender as? DetailPresentationContext) ?? .show
                if traitCollection.horizontalSizeClass == .compact {
                    context = .show
                }
                
                context.reveal(vc, in: detailNavigationController)
            } else {
                let navigationController = NavigationController(rootViewController: vc)
                super.showDetailViewController(navigationController, sender: self)
            }
        }
        
        func splitViewController(
            _ splitViewController: UISplitViewController,
            collapseSecondary secondaryViewController: UIViewController,
            onto primaryViewController: UIViewController
        ) -> Bool {
            secondaryViewController is NoContentPlaceholderViewController
        }
        
    }
    
}

// MARK: - DetailPresentationContext Revealing

extension DetailPresentationContext {
    
    func reveal(_ viewController: UIViewController, in navigationController: UINavigationController) {
        guard navigationController.viewControllers.contains(viewController) == false else { return }
        
        switch self {
        case .show:
            navigationController.pushViewController(viewController, animated: UIView.areAnimationsEnabled)
            
        case .replace:
            navigationController.setViewControllers([viewController], animated: false)
        }
    }
    
}
