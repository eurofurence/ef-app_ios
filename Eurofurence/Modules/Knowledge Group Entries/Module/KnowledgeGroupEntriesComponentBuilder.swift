import Foundation

class KnowledgeGroupEntriesComponentBuilder {

    private let interactor: KnowledgeGroupViewModelFactory
    private var sceneFactory: KnowledgeGroupEntriesSceneFactory

    init(interactor: KnowledgeGroupViewModelFactory) {
        self.interactor = interactor
        sceneFactory = StoryboardKnowledgeGroupEntriesSceneFactory()
    }

    @discardableResult
    func with(_ sceneFactory: KnowledgeGroupEntriesSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> KnowledgeGroupEntriesComponentFactory {
        KnowledgeGroupEntriesComponentFactoryImpl(
            interactor: interactor,
            sceneFactory: sceneFactory
        )
    }

}
