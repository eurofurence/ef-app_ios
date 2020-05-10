import Foundation

class KnowledgeGroupEntriesComponentBuilder {

    private let knowledgeGroupViewModelFactory: KnowledgeGroupViewModelFactory
    private var sceneFactory: KnowledgeGroupEntriesSceneFactory

    init(knowledgeGroupViewModelFactory: KnowledgeGroupViewModelFactory) {
        self.knowledgeGroupViewModelFactory = knowledgeGroupViewModelFactory
        sceneFactory = StoryboardKnowledgeGroupEntriesSceneFactory()
    }

    @discardableResult
    func with(_ sceneFactory: KnowledgeGroupEntriesSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> KnowledgeGroupEntriesComponentFactory {
        KnowledgeGroupEntriesComponentFactoryImpl(
            knowledgeGroupViewModelFactory: knowledgeGroupViewModelFactory,
            sceneFactory: sceneFactory
        )
    }

}
