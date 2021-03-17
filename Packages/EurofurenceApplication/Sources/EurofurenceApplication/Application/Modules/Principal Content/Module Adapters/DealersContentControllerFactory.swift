import DealersComponent
import UIKit

struct DealersContentControllerFactory: ApplicationModuleFactory {
    
    var dealersComponentFactory: DealersComponentFactory
    var dealersComponentDelegate: DealersComponentDelegate
    
    func makeApplicationModuleController() -> UIViewController {
        dealersComponentFactory.makeDealersComponent(dealersComponentDelegate)
    }
    
}
