import UIKit

struct NewsContentControllerFactory: ContentControllerFactory {
    
    var newsModuleProviding: NewsModuleProviding
    var newsModuleDelegate: NewsModuleDelegate
    
    func makeContentController() -> UIViewController {
        newsModuleProviding.makeNewsModule(newsModuleDelegate)
    }
    
}
