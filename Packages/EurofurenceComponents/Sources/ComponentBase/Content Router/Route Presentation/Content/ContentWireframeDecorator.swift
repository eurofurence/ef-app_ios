import UIKit

open class ContentWireframeDecorator: ContentWireframe {
    
    private let decoratedWireframe: ContentWireframe
    
    public init(decoratedWireframe: ContentWireframe) {
        self.decoratedWireframe = decoratedWireframe
    }
    
    open func presentPrimaryContentController(_ viewController: UIViewController) {
        decoratedWireframe.presentPrimaryContentController(viewController)
    }
    
    open func presentDetailContentController(_ viewController: UIViewController) {
        decoratedWireframe.presentDetailContentController(viewController)
    }
    
    open func replaceDetailContentController(_ viewController: UIViewController) {
        decoratedWireframe.replaceDetailContentController(viewController)
    }
    
}
