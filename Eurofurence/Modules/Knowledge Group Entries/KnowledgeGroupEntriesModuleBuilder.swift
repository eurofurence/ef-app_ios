import Foundation

class KnowledgeGroupEntriesModuleBuilder {

    private var interactor: KnowledgeGroupEntriesInteractor
    private var sceneFactory: KnowledgeGroupEntriesSceneFactory

    init() {
        interactor = DefaultKnowledgeGroupEntriesInteractor()
        sceneFactory = StoryboardKnowledgeGroupEntriesSceneFactory()
    }

    @discardableResult
    func with(_ interactor: KnowledgeGroupEntriesInteractor) -> KnowledgeGroupEntriesModuleBuilder {
        self.interactor = interactor
        return self
    }

    @discardableResult
    func with(_ sceneFactory: KnowledgeGroupEntriesSceneFactory) -> KnowledgeGroupEntriesModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> KnowledgeGroupEntriesModuleProviding {
        return KnowledgeGroupEntriesModule(interactor: interactor, sceneFactory: sceneFactory)
    }

}
