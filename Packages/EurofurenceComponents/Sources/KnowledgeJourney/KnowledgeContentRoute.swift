import ComponentBase
import KnowledgeGroupsComponent

public struct KnowledgeContentRoute: ContentRoute {
    
    private let presentation: KnowledgePresentation
    
    public init(presentation: KnowledgePresentation) {
        self.presentation = presentation
    }
    
    public func route(_ content: KnowledgeGroupsContentRepresentation) {
        presentation.showKnowledge()
    }
    
}
