import UIKit

public class ContentWireframeDecorator: ContentWireframe {
    
    private let decoratedWireframe: ContentWireframe
    
    public init(decoratedWireframe: ContentWireframe) {
        self.decoratedWireframe = decoratedWireframe
    }
    
    public func presentMasterContentController(_ viewController: UIViewController) {
        decoratedWireframe.presentMasterContentController(viewController)
    }
    
    public func presentDetailContentController(_ viewController: UIViewController) {
        decoratedWireframe.presentDetailContentController(viewController)
    }
    
}
