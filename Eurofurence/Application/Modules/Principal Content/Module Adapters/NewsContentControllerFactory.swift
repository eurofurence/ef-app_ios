import UIKit

struct NewsContentControllerFactory: ApplicationModuleFactory {
    
    var newsComponentFactory: NewsComponentFactory
    var newsComponentDelegate: NewsComponentDelegate
    
    func makeApplicationModuleController() -> UIViewController {
        newsComponentFactory.makeNewsComponent(newsComponentDelegate)
    }
    
}
