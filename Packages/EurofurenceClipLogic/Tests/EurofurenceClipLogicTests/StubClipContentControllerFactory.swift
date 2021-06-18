import EurofurenceClipLogic
import UIKit

struct StubClipContentControllerFactory: ClipContentControllerFactory {
    
    let contentController = UIViewController()
    
    func makeContentController() -> UIViewController {
        contentController
    }
    
}
