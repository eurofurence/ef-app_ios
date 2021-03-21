import ComponentBase

public struct ShowDealersRoute {
    
    private let tabActivator: TabWireframe
    
    public init(tabActivator: TabWireframe) {
        self.tabActivator = tabActivator
    }
    
}

// MARK: - ContentRoute

extension ShowDealersRoute: ContentRoute {
    
    public func route(_ content: DealersContentRepresentation) {
        tabActivator.activate()
    }
    
}
