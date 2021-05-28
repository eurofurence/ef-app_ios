import ComponentBase
import KnowledgeGroupsComponent

public struct ScheduleRoute: ContentRoute {
    
    private let presentation: KnowledgePresentation
    
    public init(presentation: KnowledgePresentation) {
        self.presentation = presentation
    }
    
    public func route(_ content: KnowledgeGroupsContentRepresentation) {
        presentation.showKnowledge()
    }
    
}
