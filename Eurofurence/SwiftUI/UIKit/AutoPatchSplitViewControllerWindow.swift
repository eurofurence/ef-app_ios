import EurofurenceKit
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
