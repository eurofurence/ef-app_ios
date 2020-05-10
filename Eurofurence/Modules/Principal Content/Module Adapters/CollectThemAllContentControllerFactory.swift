import UIKit

struct CollectThemAllContentControllerFactory: ApplicationModuleFactory {
    
    var collectThemAllComponentFactory: CollectThemAllComponentFactory
    
    func makeApplicationModuleController() -> UIViewController {
        collectThemAllComponentFactory.makeCollectThemAllComponent()
    }
    
}
