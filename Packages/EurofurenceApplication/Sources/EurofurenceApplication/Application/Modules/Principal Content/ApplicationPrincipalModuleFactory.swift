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
    
    private class TabBarController: UITabBarController {
        
        override func show(_ vc: UIViewController, sender: Any?) {
            selectedViewController?.show(vc, sender: sender)
        }
        
        override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
            selectedViewController?.showDetailViewController(vc, sender: sender)
        }
        
        override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            let newlySelectedIndex = tabBar.items?.firstIndex(of: item) ?? -1
            let selectingSameTab = selectedIndex == newlySelectedIndex
            
            if selectingSameTab {
                guard let viewController = viewControllers?[newlySelectedIndex] else { return }
                performHeuristicTapInteraction(viewController: viewController)
            }
        }
        
        private func performHeuristicTapInteraction(viewController: UIViewController) {
            switch viewController {
            case let viewController as UISplitViewController:
                guard let mainViewcontroller = viewController.viewControllers.first else { return }
                performHeuristicTapInteraction(viewController: mainViewcontroller)
                
            case let viewController as UINavigationController:
                if viewController.viewControllers.count > 1 {
                    viewController.popToRootViewController(animated: true)
                } else {
                    guard let topViewController = viewController.topViewController else { return }
                    performHeuristicTapInteraction(viewController: topViewController)
                }
                
            default:
                guard let tableView = viewController.view.firstDescendant(ofKind: UITableView.self) else { return }
                
                let firstIndexPath = IndexPath(item: 0, section: 0)
                tableView.scrollToRow(at: firstIndexPath, at: .top, animated: true)
            }
        }
        
    }
    
}

private extension UIView {
    
    func firstDescendant<ViewType>(ofKind kind: ViewType.Type) -> ViewType? {
        if let targetType = self as? ViewType {
            return targetType
        } else {
            for subview in subviews {
                if let targetType = subview as? ViewType {
                    return targetType
                }
            }
        }
        
        return nil
    }
    
}
