import EurofurenceComponentBase

public struct KnowledgeGroupContentRoute {
    
    private let knowledgeGroupModuleProviding: KnowledgeGroupEntriesComponentFactory
    private let contentWireframe: ContentWireframe
    private let delegate: KnowledgeGroupEntriesComponentDelegate
    
    public init(
        knowledgeGroupModuleProviding: KnowledgeGroupEntriesComponentFactory,
        contentWireframe: ContentWireframe,
        delegate: KnowledgeGroupEntriesComponentDelegate
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
        
        contentWireframe.presentPrimaryContentController(contentController)
    }
    
}
