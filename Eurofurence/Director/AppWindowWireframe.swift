import UIKit.UIViewController
import UIKit.UIWindow

struct AppWindowWireframe: WindowWireframe {

    static var shared: AppWindowWireframe = {
        guard let window = UIApplication.shared.delegate?.window, let unwrappedWindow = window else { fatalError("Application has no window") }
        return AppWindowWireframe(window: unwrappedWindow)
    }()
    
    private let window: UIWindow

    public init(window: UIWindow) {
        self.window = window
    }

    func setRoot(_ viewController: UIViewController) {
        window.rootViewController = viewController
    }

}
