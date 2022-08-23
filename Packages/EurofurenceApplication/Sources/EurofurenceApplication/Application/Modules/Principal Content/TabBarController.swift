import UIKit

class TabBarController: UITabBarController {
    
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
            guard tableView.numberOfSections > 0 && tableView.numberOfRows(inSection: 0) > 0 else { return }
            
            let firstIndexPath = IndexPath(item: 0, section: 0)
            tableView.scrollToRow(at: firstIndexPath, at: .top, animated: true)
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
