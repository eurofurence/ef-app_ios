import Eurofurence
import UIKit

struct StubContentControllerFactory: ApplicationModuleFactory {
    
    let stubInterface = UIViewController()
    func makeApplicationModuleController() -> UIViewController {
        stubInterface
    }
    
}
