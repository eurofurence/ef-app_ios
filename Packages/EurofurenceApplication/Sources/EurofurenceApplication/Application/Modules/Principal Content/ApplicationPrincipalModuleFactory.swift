import ComponentBase
import ContentController
import UIKit

public struct ApplicationPrincipalModuleFactory: PrincipalContentModuleFactory {
    
    private let applicationModuleFactories: [ApplicationModuleFactory]
    
    public init(applicationModuleFactories: [ApplicationModuleFactory]) {
        self.applicationModuleFactories = applicationModuleFactories
    }
    
    public func makePrincipalContentModule() -> UIViewController {
        let applicationModules = applicationModuleFactories.map({ $0.makeApplicationModuleController() })
        let navigationControllers = applicationModules.map(BrandedNavigationController.init)
        let splitViewControllers = navigationControllers.map { (navigationController) -> UISplitViewController in
            let splitViewController = BrandedSplitViewController()
            let noContentPlaceholder = NoContentPlaceholderViewController.fromStoryboard()
            let noContentNavigation = UINavigationController(rootViewController: noContentPlaceholder)
            splitViewController.viewControllers = [navigationController, noContentNavigation]
            splitViewController.tabBarItem = navigationController.tabBarItem
            
            return splitViewController
        }
        
        let tabBarController = TabBarController()
        tabBarController.viewControllers = splitViewControllers
        
        return tabBarController
    }
    
}
