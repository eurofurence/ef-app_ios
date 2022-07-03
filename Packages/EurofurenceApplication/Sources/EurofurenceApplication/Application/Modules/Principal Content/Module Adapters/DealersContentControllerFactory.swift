import DealersComponent
import UIKit

struct DealersContentControllerFactory: ApplicationModuleFactory {
    
    var dealersComponentFactory: DealersComponentFactory
    var dealersComponentDelegate: DealersComponentDelegate
    
    func makeApplicationModuleController() -> UIViewController {
        let viewController = dealersComponentFactory.makeDealersComponent(dealersComponentDelegate)
        viewController.tabBarItem.image = UIImage(systemName: "cart", compatibleWith: nil)
        viewController.tabBarItem.selectedImage = UIImage(systemName: "cart.fill", compatibleWith: nil)
        
        return viewController
    }
    
}
