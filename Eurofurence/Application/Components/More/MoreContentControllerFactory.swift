import UIKit

struct MoreContentControllerFactory: ApplicationModuleFactory {
    
    var supplementaryContentControllerFactories: [SupplementaryContentController]
    
    func makeApplicationModuleController() -> UIViewController {
        MoreViewController(supplementaryApplicationModuleFactories: supplementaryContentControllerFactories)
    }
    
}

struct SupplementaryContentController {
    
    var contentControllerFactory: ApplicationModuleFactory
    var presentationHandler: (UIViewController) -> Void
    
}
