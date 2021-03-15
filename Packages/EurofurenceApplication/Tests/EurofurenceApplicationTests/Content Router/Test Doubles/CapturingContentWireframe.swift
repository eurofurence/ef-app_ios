import EurofurenceApplication
import UIKit.UIViewController

class CapturingContentWireframe: ContentWireframe {
    
    private(set) var presentedPrimaryContentController: UIViewController?
    func presentPrimaryContentController(_ viewController: UIViewController) {
        presentedPrimaryContentController = viewController
    }
    
    private(set) var presentedDetailContentController: UIViewController?
    func presentDetailContentController(_ viewController: UIViewController) {
        presentedDetailContentController = viewController
    }
    
    private(set) var replacedDetailContentController: UIViewController?
    func replaceDetailContentController(_ viewController: UIViewController) {
        replacedDetailContentController = viewController
    }
    
}
