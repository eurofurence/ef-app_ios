import KnowledgeGroupsComponent
import RouterCore

public struct KnowledgeRoute: Route {
    
    private let presentation: KnowledgePresentation
    
    public init(presentation: KnowledgePresentation) {
        self.presentation = presentation
    }
    
    public func route(_ content: KnowledgeGroupsRouteable) {
        presentation.showKnowledge()
    }
    
}
