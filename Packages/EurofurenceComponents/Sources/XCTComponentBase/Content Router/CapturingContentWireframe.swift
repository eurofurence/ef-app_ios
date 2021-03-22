import ComponentBase
import UIKit.UIViewController

public class CapturingContentWireframe: ContentWireframe {
    
    public init() {
        
    }
    
    public private(set) var presentedPrimaryContentController: UIViewController?
    public func presentPrimaryContentController(_ viewController: UIViewController) {
        presentedPrimaryContentController = viewController
    }
    
    public private(set) var presentedDetailContentController: UIViewController?
    public func presentDetailContentController(_ viewController: UIViewController) {
        presentedDetailContentController = viewController
    }
    
    public private(set) var replacedDetailContentController: UIViewController?
    public func replaceDetailContentController(_ viewController: UIViewController) {
        replacedDetailContentController = viewController
    }
    
}
