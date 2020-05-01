import Eurofurence
import UIKit.UIViewController

class CapturingContentWireframe: ContentWireframe {
    
    private(set) var presentedNewsContentController: UIViewController?
    func presentNewsContentController(_ viewController: UIViewController) {
        presentedNewsContentController = viewController
    }
    
}
