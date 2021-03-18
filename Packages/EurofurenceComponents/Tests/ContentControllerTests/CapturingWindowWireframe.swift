import ContentController
import UIKit.UIViewController

class CapturingWindowWireframe: WindowWireframe {

    private(set) var capturedRootInterface: UIViewController?
    func setRoot(_ viewController: UIViewController) {
        capturedRootInterface = viewController
    }

}
