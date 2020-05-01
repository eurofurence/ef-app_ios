import Eurofurence
import UIKit.UIViewController

class CapturingContentWireframe: ContentWireframe {
    
    private(set) var presentedNewsContentController: UIViewController?
    func presentNewsContentController(_ viewController: UIViewController) {
        presentedNewsContentController = viewController
    }
    
    private(set) var presentedDetailContentController: UIViewController?
    func presentDetailContentController(_ viewController: UIViewController) {
        presentedDetailContentController = viewController
    }
    
}
