import UIKit

struct WindowContentWireframe: ContentWireframe {
    
    var window: UIWindow
    
    func presentPrimaryContentController(_ viewController: UIViewController) {
        window.rootViewController?.show(viewController, sender: nil)
    }
    
    func presentDetailContentController(_ viewController: UIViewController) {
        window.rootViewController?.showDetailViewController(viewController, sender: DetailPresentationContext.show)
    }
    
    func replaceDetailContentController(_ viewController: UIViewController) {
        window.rootViewController?.showDetailViewController(viewController, sender: DetailPresentationContext.replace)
    }
    
}
