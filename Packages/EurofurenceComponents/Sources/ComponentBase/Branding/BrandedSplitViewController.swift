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
        // Collapsing works as follows: the primary view controller consumes the secondary view controller, unless it
        // is a navigation controller. Instead, it consumes all of the secondary view cotroller's children. The only
        // exception is placeholder controllers, which are discarded.
        guard let primaryNavigationController = primaryViewController as? UINavigationController else { return false }
        
        var viewControllers = [UIViewController]()
        if let secondaryNavigationController = secondaryViewController as? UINavigationController {
            viewControllers = secondaryNavigationController.viewControllers
        } else {
            viewControllers = [secondaryViewController]
        }
        
        viewControllers.removeAll(where: { $0 is NoContentPlaceholderViewController })
        for viewController in viewControllers {
            primaryNavigationController.pushViewController(viewController, animated: false)
        }
        
        return true
    }
    
    public func splitViewController(
        _ splitViewController: UISplitViewController,
        separateSecondaryFrom primaryViewController: UIViewController
    ) -> UIViewController? {
        // Seperating works as follows: the primary view controller is expected to be navigation controller composed
        // of the primary content controller and, optionally, zero to many secondary controllers. The primary view
        // controllers will remain in the primary panel, with all secondary view controllers moved into the secondary
        // panel.
        // In the event the primary view controller is composed of a singular view controller (e.g. no content has
        // been disclosed yet), the secondary panel will instead house a new placeholder view controller.
        guard let navigationController = primaryViewController as? UINavigationController else { return nil }
        
        if navigationController.viewControllers.count == 1 {
            // Only one view controller exists - the secondary panel should house a new placeholder controller.
            let noContentController = NoContentPlaceholderViewController.fromStoryboard()
            return UINavigationController(rootViewController: noContentController)
        } else {
            guard let lastViewController = navigationController.viewControllers.last else { return nil }
            
            let secondaryViewController: UIViewController
            if lastViewController is PrimaryContentPane {
                // The terminal view controller should move back into the primary pane of the split view, instead of
                // being moved into the secondary pane.
                // As there are no further children to disclose into the secondary pane, use the placeholder view.
                let noContentViewController = NoContentPlaceholderViewController.fromStoryboard()
                secondaryViewController = UINavigationController(rootViewController: noContentViewController)
            } else {
                // The terminal view controller should be shifted into the secondary pane. All preceding children
                // contained in the navigation view will remain in the primary pane.
                let terminalViewController: UIViewController?
                if let brandedNavigationController = navigationController as? BrandedNavigationController {
                    terminalViewController = brandedNavigationController.popLastWithoutClearingSelection()
                } else {
                    terminalViewController = navigationController.popViewController(animated: false)
                }
                
                guard let viewControllerToShift = terminalViewController else { return nil }
                
                if viewControllerToShift is UINavigationController {
                    secondaryViewController = viewControllerToShift
                } else {
                    secondaryViewController = UINavigationController(rootViewController: viewControllerToShift)
                }
            }
            
            return secondaryViewController
        }
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
