import Eurofurence
import UIKit.UIViewController

class CapturingModalWireframe: ModalWireframe {
    
    private(set) var presentedModalContentController: UIViewController?
    func presentModalContentController(_ viewController: UIViewController) {
        presentedModalContentController = viewController
    }
    
}
