import ComponentBase
import RouterCore

public struct KnowledgeEntryRoute {
    
    private let knowledgeDetailComponentFactory: KnowledgeDetailComponentFactory
    private let contentWireframe: ContentWireframe
    private let delegate: KnowledgeDetailComponentDelegate
    
    public init(
        knowledgeDetailComponentFactory: KnowledgeDetailComponentFactory,
        contentWireframe: ContentWireframe,
        delegate: KnowledgeDetailComponentDelegate
    ) {
        self.knowledgeDetailComponentFactory = knowledgeDetailComponentFactory
        self.contentWireframe = contentWireframe
        self.delegate = delegate
    }
    
}

// MARK: - Route

extension KnowledgeEntryRoute: Route {
    
    public typealias Parameter = KnowledgeEntryRouteable
    
    public func route(_ content: KnowledgeEntryRouteable) {
        let contentController = knowledgeDetailComponentFactory.makeKnowledgeListComponent(
            content.identifier,
            delegate: delegate
        )
        
        contentWireframe.replaceDetailContentController(contentController)
    }
    
}
