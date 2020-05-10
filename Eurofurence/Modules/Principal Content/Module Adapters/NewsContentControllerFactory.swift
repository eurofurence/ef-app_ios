import UIKit

struct NewsContentControllerFactory: ApplicationModuleFactory {
    
    var newsModuleProviding: NewsModuleProviding
    var newsModuleDelegate: NewsModuleDelegate
    
    func makeApplicationModuleController() -> UIViewController {
        newsModuleProviding.makeNewsModule(newsModuleDelegate)
    }
    
}
