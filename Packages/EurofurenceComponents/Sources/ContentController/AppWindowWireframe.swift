import UIKit.UIViewController
import UIKit.UIWindow

public struct AppWindowWireframe: WindowWireframe {
    
    private let window: UIWindow

    public init(window: UIWindow) {
        self.window = window
    }

    public func setRoot(_ viewController: UIViewController) {
        let transition = CATransition()
        transition.type = .fade
        transition.subtype = nil
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: .linear)
        
        window.layer.add(transition, forKey: kCATransition)
        window.rootViewController = viewController
    }

}
