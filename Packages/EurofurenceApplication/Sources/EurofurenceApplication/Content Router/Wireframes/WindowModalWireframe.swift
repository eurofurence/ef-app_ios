import UIKit

struct WindowModalWireframe: ModalWireframe {
    
    var window: UIWindow
    
    func presentModalContentController(_ viewController: UIViewController, completion: (() -> Void)?) {
        window.rootViewController?.present(viewController, animated: true, completion: completion)
    }
    
}
