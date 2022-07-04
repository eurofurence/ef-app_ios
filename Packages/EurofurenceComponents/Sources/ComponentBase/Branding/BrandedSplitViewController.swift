import UIKit

public class BrandedSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        delegate = self
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        extendedLayoutIncludesOpaqueBars = true
        preferredDisplayMode = .allVisible
    }
    
    override public func show(_ vc: UIViewController, sender: Any?) {
        let primary = viewControllers.first
        
        if let primary = primary as? UINavigationController, isOnlyShowingPlaceholderContent(primary) == false {
            primary.pushViewController(vc, animated: UIView.areAnimationsEnabled)
        } else {
            super.show(vc, sender: sender)
        }
    }
    
    override public func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        let isCompact = traitCollection.horizontalSizeClass == .compact
        let targetViewController = isCompact ? viewControllers.first : viewControllers.last
        
        if let detailNavigationController = targetViewController as? UINavigationController {
            var context = (sender as? DetailPresentationContext) ?? .show
            if traitCollection.horizontalSizeClass == .compact {
                context = .show
            }
            
            context.reveal(vc, in: detailNavigationController)
        } else {
            let navigationController = BrandedNavigationController(rootViewController: vc)
            super.showDetailViewController(navigationController, sender: self)
        }
    }
    
    public func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
    ) -> Bool {
        isPlaceholderContentController(secondaryViewController)
    }
    
    public func splitViewController(
        _ splitViewController: UISplitViewController,
        separateSecondaryFrom primaryViewController: UIViewController
    ) -> UIViewController? {
        guard let navigationController = primaryViewController as? UINavigationController else { return nil }
        guard navigationController.viewControllers.count > 1 else { return nil }
        guard let lastViewController = navigationController.popViewController(animated: false) else { return nil }
        
        let secondaryViewController: UIViewController
        if lastViewController is PrimaryContentPane {
            // The terminal view controller should move back into the primary pane of the split view, instead of being
            // moved into the secondary pane.
            navigationController.pushViewController(lastViewController, animated: false)
            
            // As there are no further children to disclose into the secondary pane, use the placeholder view.
            let noContentViewController = NoContentPlaceholderViewController.fromStoryboard()
            secondaryViewController = UINavigationController(rootViewController: noContentViewController)
        } else {
            // The terminal view controller should be shifted into the secondary pane. All preceding children contained
            // in the navigation view will remain in the priary pane.
            if let embeddedNavigationController = lastViewController as? UINavigationController {
                secondaryViewController = embeddedNavigationController
            } else {
                secondaryViewController = UINavigationController(rootViewController: lastViewController)
            }
        }
        
        return secondaryViewController
    }
    
    private func isPlaceholderContentController(_ viewController: UIViewController) -> Bool {
        if let navigationController = viewController as? UINavigationController {
            return navigationController.viewControllers.first is NoContentPlaceholderViewController
        } else {
            return viewController is NoContentPlaceholderViewController
        }
    }
    
    private func isOnlyShowingPlaceholderContent(_ navigationController: UINavigationController) -> Bool {
        let onlyOneController = navigationController.viewControllers.count == 1
        let topControllerIsNoContent = navigationController.topViewController is NoContentPlaceholderViewController
        
        return onlyOneController && topControllerIsNoContent
    }
    
}
