import UIKit

class AutoPatchSplitViewControllerWindow: UIWindow {
    
    override var rootViewController: UIViewController? {
        didSet {
            if let rootViewController = rootViewController {
                applySplitViewControllerPatch(to: rootViewController)
            }
        }
    }
    
    private func applySplitViewControllerPatch(to rootViewController: UIViewController) {
        // We need to let the current run of the RunLoop conclude before we have access to the window's root
        // view controller.
        DispatchQueue.main.async { @MainActor in
            if let splitViewController = rootViewController.firstDescendent(ofType: UISplitViewController.self) {
                splitViewController.preferredDisplayMode = .twoBesideSecondary
            }
        }
    }
    
}

private extension UIViewController {
    
    func firstDescendent<T>(ofType type: T.Type) -> T? where T: UIViewController {
        if let target = self as? T {
            return target
        }
        
        for child in children {
            if let target = child as? T {
                return target
            } else {
                if let target = child.firstDescendent(ofType: type) {
                    return target
                }
            }
        }
        
        return nil
    }
    
}
