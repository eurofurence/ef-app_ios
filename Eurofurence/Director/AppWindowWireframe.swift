import UIKit.UIViewController
import UIKit.UIWindow

struct AppWindowWireframe: WindowWireframe {

    static var shared: AppWindowWireframe = {
        let window = UIApplication.shared.delegate!.window!!
        return AppWindowWireframe(window: window)
    }()

    var window: UIWindow

    func setRoot(_ viewController: UIViewController) {
        window.rootViewController = viewController
    }

}
