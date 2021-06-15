import EurofurenceClipLogic
import UIKit

class CapturingReplaceRootWireframe: ReplaceRootWireframe {
    
    private(set) var currentRoot: UIViewController?
    func replaceRoot(with newRoot: UIViewController) {
        currentRoot = newRoot
    }
    
}
