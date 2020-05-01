import Eurofurence
import UIKit.UIViewController

class CapturingModalWireframe: ModalWireframe {
    
    private(set) var presentedModalContentController: UIViewController?
    private(set) var presentedCompletionHandler: (() -> Void)?
    func presentModalContentController(_ viewController: UIViewController, completion: (() -> Void)?) {
        presentedModalContentController = viewController
        presentedCompletionHandler = completion
    }
    
}
