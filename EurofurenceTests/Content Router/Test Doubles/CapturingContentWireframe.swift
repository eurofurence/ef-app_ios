import Eurofurence
import UIKit.UIViewController

class CapturingContentWireframe: ContentWireframe {
    
    private(set) var presentedMasterContentController: UIViewController?
    func presentMasterContentController(_ viewController: UIViewController) {
        presentedMasterContentController = viewController
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
