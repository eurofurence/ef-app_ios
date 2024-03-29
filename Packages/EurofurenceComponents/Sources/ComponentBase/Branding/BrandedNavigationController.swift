import UIKit

public class BrandedNavigationController: UINavigationController {
    
    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        tabBarItem = rootViewController.tabBarItem
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
    }
    
    override public var viewControllers: [UIViewController] {
        didSet {
            clearSelectionInTopmostViewController(animated: false)
        }
    }
    
    override public func popViewController(animated: Bool) -> UIViewController? {
        let viewController = super.popViewController(animated: animated)
        clearSelectionInTopmostViewController(animated: animated)
        
        return viewController
    }
    
    override public func popToViewController(
        _ viewController: UIViewController,
        animated: Bool
    ) -> [UIViewController]? {
        let viewControllers = super.popToViewController(viewController, animated: animated)
        clearSelectionInTopmostViewController(animated: animated)
        
        return viewControllers
    }
    
    override public func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let viewControllers = super.popToRootViewController(animated: animated)
        clearSelectionInTopmostViewController(animated: animated)
        
        return viewControllers
    }
    
    func popLastWithoutClearingSelection() -> UIViewController? {
        super.popViewController(animated: false)
    }
    
    private func clearSelectionInTopmostViewController(animated: Bool) {
        guard let topViewController = topViewController else { return }
        guard let tableView = findTableView(in: topViewController.view) else { return }
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        
        tableView.deselectRow(at: selectedIndexPath, animated: animated)
    }
    
    private func findTableView(in view: UIView) -> UITableView? {
        if let tableView = view as? UITableView {
            return tableView
        } else {
            for subview in view.subviews {
                if let tableView = findTableView(in: subview) {
                    return tableView
                }
            }
            
            return nil
        }
    }
    
}
