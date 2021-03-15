import UIKit.UIViewController
import UIKit.UIWindow

struct AppWindowWireframe: WindowWireframe {
    
    private let window: UIWindow

    public init(window: UIWindow) {
        self.window = window
    }

    func setRoot(_ viewController: UIViewController) {
        let transition = CATransition()
        transition.type = .fade
        transition.subtype = nil
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: .linear)
        
        window.layer.add(transition, forKey: kCATransition)
        window.rootViewController = viewController
    }

}
