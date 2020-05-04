public struct KnowledgeEntryContentRoute {
    
    private let knowledgeDetailModuleProviding: KnowledgeDetailModuleProviding
    private let contentWireframe: ContentWireframe
    private let delegate: KnowledgeDetailModuleDelegate
    
    public init(
        knowledgeDetailModuleProviding: KnowledgeDetailModuleProviding,
        contentWireframe: ContentWireframe,
        delegate: KnowledgeDetailModuleDelegate
    ) {
        self.knowledgeDetailModuleProviding = knowledgeDetailModuleProviding
        self.contentWireframe = contentWireframe
        self.delegate = delegate
    }
    
}

// MARK: - ContentRoute

extension KnowledgeEntryContentRoute: ContentRoute {
    
    public typealias Content = KnowledgeEntryContentRepresentation
    
    public func route(_ content: KnowledgeEntryContentRepresentation) {
        let contentController = knowledgeDetailModuleProviding.makeKnowledgeListModule(
            content.identifier,
            delegate: delegate
        )
        
        contentWireframe.presentDetailContentController(contentController)
    }
    
}
