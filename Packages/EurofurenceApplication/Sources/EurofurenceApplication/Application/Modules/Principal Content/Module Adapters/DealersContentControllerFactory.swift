import DealersComponent
import UIKit

struct DealersContentControllerFactory: ApplicationModuleFactory {
    
    var dealersComponentFactory: DealersComponentFactory
    var dealersComponentDelegate: DealersComponentDelegate
    
    func makeApplicationModuleController() -> UIViewController {
        let viewController = dealersComponentFactory.makeDealersComponent(dealersComponentDelegate)
        viewController.tabBarItem.image = UIImage(named: "dealers", in: .module, compatibleWith: nil)
        
        return viewController
    }
    
}
