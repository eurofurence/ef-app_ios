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
    
    private func isPlaceholderContentController(_ viewController: UIViewController) -> Bool {
        guard let navigationController = viewController as? UINavigationController else { return false }
        return navigationController.viewControllers.first is NoContentPlaceholderViewController
    }
    
    private func isOnlyShowingPlaceholderContent(_ navigationController: UINavigationController) -> Bool {
        let onlyOneController = navigationController.viewControllers.count == 1
        let topControllerIsNoContent = navigationController.topViewController is NoContentPlaceholderViewController
        
        return onlyOneController && topControllerIsNoContent
    }
    
}
