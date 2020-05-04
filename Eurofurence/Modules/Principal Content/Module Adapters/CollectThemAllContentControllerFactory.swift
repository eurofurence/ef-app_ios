import UIKit

struct CollectThemAllContentControllerFactory: ContentControllerFactory {
    
    var collectThemAllModuleProviding: CollectThemAllModuleProviding
    
    func makeContentController() -> UIViewController {
        collectThemAllModuleProviding.makeCollectThemAllModule()
    }
    
}
