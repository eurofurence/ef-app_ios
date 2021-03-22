import ComponentBase
import UIKit.UIViewController

public class CapturingModalWireframe: ModalWireframe {
    
    public init() {
        
    }
    
    public private(set) var presentedModalContentController: UIViewController?
    public private(set) var presentedCompletionHandler: (() -> Void)?
    public func presentModalContentController(_ viewController: UIViewController, completion: (() -> Void)?) {
        presentedModalContentController = viewController
        presentedCompletionHandler = completion
    }
    
}
