import UIKit

public class ContentWireframeDecorator: ContentWireframe {
    
    private let decoratedWireframe: ContentWireframe
    
    public init(decoratedWireframe: ContentWireframe) {
        self.decoratedWireframe = decoratedWireframe
    }
    
    public func presentPrimaryContentController(_ viewController: UIViewController) {
        decoratedWireframe.presentPrimaryContentController(viewController)
    }
    
    public func presentDetailContentController(_ viewController: UIViewController) {
        decoratedWireframe.presentDetailContentController(viewController)
    }
    
    public func replaceDetailContentController(_ viewController: UIViewController) {
        decoratedWireframe.replaceDetailContentController(viewController)
    }
    
}
