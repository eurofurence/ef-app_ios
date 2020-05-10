import UIKit

struct MoreContentControllerFactory: ApplicationModuleFactory {
    
    var supplementaryContentControllerFactories: [ApplicationModuleFactory]
    
    func makeApplicationModuleController() -> UIViewController {
        MoreViewController(supplementaryApplicationModuleFactories: supplementaryContentControllerFactories)
    }
    
}
