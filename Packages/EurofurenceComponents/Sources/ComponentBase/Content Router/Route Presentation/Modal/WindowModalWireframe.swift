import UIKit

public struct WindowModalWireframe: ModalWireframe {
    
    private let window: UIWindow
    
    public init(window: UIWindow) {
        self.window = window
    }
    
    public func presentModalContentController(_ viewController: UIViewController, completion: (() -> Void)?) {
        window.rootViewController?.present(viewController, animated: true, completion: completion)
    }
    
}
