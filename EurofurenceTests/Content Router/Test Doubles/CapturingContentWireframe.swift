import Eurofurence
import UIKit.UIViewController

class CapturingContentWireframe: ContentWireframe {
    
    private(set) var presentedDetailContentController: UIViewController?
    func presentDetailContentController(_ viewController: UIViewController) {
        presentedDetailContentController = viewController
    }
    
}
