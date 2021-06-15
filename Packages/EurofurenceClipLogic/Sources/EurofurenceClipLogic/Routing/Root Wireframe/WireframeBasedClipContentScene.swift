import UIKit

public struct WireframeBasedClipContentScene: ClipContentScene {
    
    private let wireframe: ReplaceRootWireframe
    private let scheduleComponent: ClipContentControllerFactory
    private let dealersComponent: ClipContentControllerFactory
    
    public init(
        wireframe: ReplaceRootWireframe,
        scheduleComponent: ClipContentControllerFactory,
        dealersComponent: ClipContentControllerFactory
    ) {
        self.wireframe = wireframe
        self.scheduleComponent = scheduleComponent
        self.dealersComponent = dealersComponent
    }
    
    public func prepareForShowingEvents() {
        wireframe.replaceRoot(with: scheduleComponent.makeContentController())
    }
    
    public func prepareForShowingDealers() {
        wireframe.replaceRoot(with: dealersComponent.makeContentController())
    }
    
}
