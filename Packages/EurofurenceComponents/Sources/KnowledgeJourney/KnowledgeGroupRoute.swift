import ComponentBase
import KnowledgeGroupComponent
import RouterCore

public struct KnowledgeGroupRoute {
    
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

// MARK: - Route

extension KnowledgeGroupRoute: Route {
    
    public typealias Parameter = KnowledgeGroupRouteable
    
    public func route(_ content: KnowledgeGroupRouteable) {
        let contentController = knowledgeGroupModuleProviding.makeKnowledgeGroupEntriesModule(
            content.identifier,
            delegate: delegate
        )
        
        contentWireframe.presentPrimaryContentController(contentController)
    }
    
}
