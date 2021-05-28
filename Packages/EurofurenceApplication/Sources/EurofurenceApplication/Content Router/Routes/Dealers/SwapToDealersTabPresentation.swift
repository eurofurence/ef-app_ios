import DealersJourney

public struct SwapToDealersTabPresentation: DealersPresentation {
    
    private let tabNavigator: TabNavigator
    
    public init(tabNavigator: TabNavigator) {
        self.tabNavigator = tabNavigator
    }
    
    public func showDealers() {
        tabNavigator.moveToTab()
    }
    
}
