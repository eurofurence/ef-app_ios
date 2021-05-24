import ComponentBase
import DealersComponent

public struct ShowDealersRoute {
    
    private let tabNavigator: TabNavigator
    
    public init(tabNavigator: TabNavigator) {
        self.tabNavigator = tabNavigator
    }
    
}

// MARK: - ContentRoute

extension ShowDealersRoute: ContentRoute {
    
    public func route(_ content: DealersContentRepresentation) {
        tabNavigator.moveToTab()
    }
    
}
