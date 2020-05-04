import UIKit

struct MoreContentControllerFactory: ContentControllerFactory {
    
    var supplementaryContentControllerFactories: [ContentControllerFactory]
    
    func makeContentController() -> UIViewController {
        MoreViewController(supplementaryContentControllerFactories: supplementaryContentControllerFactories)
    }
    
}
