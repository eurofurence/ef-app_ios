import UIKit

public struct PrincipalContentAggregator: PrincipalContentModuleProviding {
    
    private let contentControllerFactories: [ContentControllerFactory]
    
    public init(contentControllerFactories: [ContentControllerFactory]) {
        self.contentControllerFactories = contentControllerFactories
    }
    
    public func makePrincipalContentModule() -> UIViewController {
        let contentControllers = contentControllerFactories.map({ $0.makeContentController() })
        let navigationControllers = contentControllers.map(UINavigationController.init)
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = navigationControllers
        
        return tabBarController
    }
    
}
