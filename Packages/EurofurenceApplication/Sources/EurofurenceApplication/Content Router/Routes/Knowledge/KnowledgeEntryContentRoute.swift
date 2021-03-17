import ComponentBase

public struct KnowledgeEntryContentRoute {
    
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

// MARK: - ContentRoute

extension KnowledgeEntryContentRoute: ContentRoute {
    
    public typealias Content = KnowledgeEntryContentRepresentation
    
    public func route(_ content: KnowledgeEntryContentRepresentation) {
        let contentController = knowledgeDetailComponentFactory.makeKnowledgeListComponent(
            content.identifier,
            delegate: delegate
        )
        
        contentWireframe.replaceDetailContentController(contentController)
    }
    
}
