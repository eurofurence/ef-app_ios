import KnowledgeJourney

public struct SwapToKnowledgeTabPresentation: KnowledgePresentation {
    
    private let tabNavigator: TabNavigator
    
    public init(tabNavigator: TabNavigator) {
        self.tabNavigator = tabNavigator
    }
    
    public func showKnowledge() {
        tabNavigator.moveToTab()
    }
    
}
