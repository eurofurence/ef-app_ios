import UIKit

struct DealersContentControllerFactory: ApplicationModuleFactory {
    
    var dealersModuleProviding: DealersModuleProviding
    var dealersModuleDelegate: DealersModuleDelegate
    
    func makeApplicationModuleController() -> UIViewController {
        dealersModuleProviding.makeDealersModule(dealersModuleDelegate)
    }
    
}
