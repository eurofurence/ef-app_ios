import UIKit

struct CollectThemAllContentControllerFactory: ApplicationModuleFactory {
    
    var collectThemAllModuleProviding: CollectThemAllModuleProviding
    
    func makeApplicationModuleController() -> UIViewController {
        collectThemAllModuleProviding.makeCollectThemAllModule()
    }
    
}
