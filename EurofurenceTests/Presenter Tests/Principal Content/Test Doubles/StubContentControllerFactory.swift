import Eurofurence
import UIKit

struct StubContentControllerFactory: ContentControllerFactory {
    
    let stubInterface = UIViewController()
    func makeContentController() -> UIViewController {
        stubInterface
    }
    
}
