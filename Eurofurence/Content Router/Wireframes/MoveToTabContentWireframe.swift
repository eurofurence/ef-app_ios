import UIKit

public class MoveToTabContentWireframe: ContentWireframeDecorator {
    
    private let tabSwapper: TabNavigator
    
    public init(decoratedWireframe: ContentWireframe, tabSwapper: TabNavigator) {
        self.tabSwapper = tabSwapper
        super.init(decoratedWireframe: decoratedWireframe)
    }
    
    override public func presentDetailContentController(_ viewController: UIViewController) {
        tabSwapper.moveToTab()
        super.presentDetailContentController(viewController)
    }
    
}
