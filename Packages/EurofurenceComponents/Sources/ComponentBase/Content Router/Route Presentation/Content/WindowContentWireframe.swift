import UIKit

public struct WindowContentWireframe: ContentWireframe {
    
    private let window: UIWindow
    
    public init(window: UIWindow) {
        self.window = window
    }
    
    public func presentPrimaryContentController(_ viewController: UIViewController) {
        window.rootViewController?.show(viewController, sender: nil)
    }
    
    public func presentDetailContentController(_ viewController: UIViewController) {
        window.rootViewController?.showDetailViewController(viewController, sender: DetailPresentationContext.show)
    }
    
    public func replaceDetailContentController(_ viewController: UIViewController) {
        window.rootViewController?.showDetailViewController(viewController, sender: DetailPresentationContext.replace)
    }
    
}
