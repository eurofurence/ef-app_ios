import UIKit

struct DealersContentControllerFactory: ContentControllerFactory {
    
    var dealersModuleProviding: DealersModuleProviding
    var dealersModuleDelegate: DealersModuleDelegate
    
    func makeContentController() -> UIViewController {
        dealersModuleProviding.makeDealersModule(dealersModuleDelegate)
    }
    
}
