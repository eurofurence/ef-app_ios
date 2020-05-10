import Foundation

class KnowledgeDetailComponentBuilder {

    private var knowledgeDetailSceneFactory: KnowledgeDetailSceneFactory
    private let knowledgeDetailViewModelFactory: KnowledgeDetailViewModelFactory

    init(knowledgeDetailViewModelFactory: KnowledgeDetailViewModelFactory) {
        self.knowledgeDetailViewModelFactory = knowledgeDetailViewModelFactory
        knowledgeDetailSceneFactory = StoryboardKnowledgeDetailSceneFactory()
    }

    @discardableResult
    func with(_ knowledgeDetailSceneFactory: KnowledgeDetailSceneFactory) -> Self {
        self.knowledgeDetailSceneFactory = knowledgeDetailSceneFactory
        return self
    }

    func build() -> KnowledgeDetailComponentFactory {
        KnowledgeDetailComponentFactoryImpl(
            knowledgeDetailSceneFactory: knowledgeDetailSceneFactory,
            knowledgeDetailViewModelFactory: knowledgeDetailViewModelFactory
        )
    }

}
