import UIKit.UIViewController

public protocol ModalWireframe {
    
    func presentModalContentController(
        _ viewController: UIViewController,
        completion: (() -> Void)?
    )
    
}

extension ModalWireframe {
    
    public func presentModalContentController(_ viewController: UIViewController) {
        presentModalContentController(viewController, completion: nil)
    }
    
}
