import Foundation

class KnowledgeGroupEntriesModuleBuilder {

    private let interactor: KnowledgeGroupEntriesInteractor
    private var sceneFactory: KnowledgeGroupEntriesSceneFactory

    init(interactor: KnowledgeGroupEntriesInteractor) {
        self.interactor = interactor
        sceneFactory = StoryboardKnowledgeGroupEntriesSceneFactory()
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
