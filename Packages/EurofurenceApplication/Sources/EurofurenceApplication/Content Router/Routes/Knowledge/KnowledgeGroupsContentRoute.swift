import ComponentBase
import Foundation
import KnowledgeGroupsComponent

public struct KnowledgeGroupsContentRoute {
    
    private let tabNavigator: TabNavigator
    
    public init(tabNavigator: TabNavigator) {
        self.tabNavigator = tabNavigator
    }
    
}

// MARK: - ContentRoute

extension KnowledgeGroupsContentRoute: ContentRoute {
    
    public typealias Content = KnowledgeGroupsContentRepresentation
    
    public func route(_ content: KnowledgeGroupsContentRepresentation) {
        tabNavigator.moveToTab()
    }
    
}
