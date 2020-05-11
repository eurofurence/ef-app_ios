import Foundation

public class KnowledgeDetailComponentBuilder {

    private var knowledgeDetailSceneFactory: KnowledgeDetailSceneFactory
    private let knowledgeDetailViewModelFactory: KnowledgeDetailViewModelFactory

    public init(knowledgeDetailViewModelFactory: KnowledgeDetailViewModelFactory) {
        self.knowledgeDetailViewModelFactory = knowledgeDetailViewModelFactory
        knowledgeDetailSceneFactory = StoryboardKnowledgeDetailSceneFactory()
    }

    @discardableResult
    public func with(_ knowledgeDetailSceneFactory: KnowledgeDetailSceneFactory) -> Self {
        self.knowledgeDetailSceneFactory = knowledgeDetailSceneFactory
        return self
    }

    public func build() -> KnowledgeDetailComponentFactory {
        KnowledgeDetailComponentFactoryImpl(
            knowledgeDetailSceneFactory: knowledgeDetailSceneFactory,
            knowledgeDetailViewModelFactory: knowledgeDetailViewModelFactory
        )
    }

}
