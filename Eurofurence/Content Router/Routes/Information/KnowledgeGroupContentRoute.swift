public struct KnowledgeGroupContentRoute {
    
    private let knowledgeGroupModuleProviding: KnowledgeGroupEntriesModuleProviding
    private let contentWireframe: ContentWireframe
    private let delegate: KnowledgeGroupEntriesModuleDelegate
    
    public init(
        knowledgeGroupModuleProviding: KnowledgeGroupEntriesModuleProviding,
        contentWireframe: ContentWireframe,
        delegate: KnowledgeGroupEntriesModuleDelegate
    ) {
        self.knowledgeGroupModuleProviding = knowledgeGroupModuleProviding
        self.contentWireframe = contentWireframe
        self.delegate = delegate
    }
    
}

// MARK: - ContentRoute

extension KnowledgeGroupContentRoute: ContentRoute {
    
    public typealias Content = KnowledgeGroupContentRepresentation
    
    public func route(_ content: KnowledgeGroupContentRepresentation) {
        let contentController = knowledgeGroupModuleProviding.makeKnowledgeGroupEntriesModule(
            content.identifier,
            delegate: delegate
        )
        
        contentWireframe.presentMasterContentController(contentController)
    }
    
}
