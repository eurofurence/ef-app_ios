import Foundation

class KnowledgeDetailModuleBuilder {

    private var knowledgeDetailSceneFactory: KnowledgeDetailSceneFactory
    private var knowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor

    init() {
        knowledgeDetailSceneFactory = StoryboardKnowledgeDetailSceneFactory()
        knowledgeDetailSceneInteractor = DefaultKnowledgeDetailSceneInteractor()
    }

    @discardableResult
    func with(_ knowledgeDetailSceneFactory: KnowledgeDetailSceneFactory) -> KnowledgeDetailModuleBuilder {
        self.knowledgeDetailSceneFactory = knowledgeDetailSceneFactory
        return self
    }

    @discardableResult
    func with(_ knowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor) -> KnowledgeDetailModuleBuilder {
        self.knowledgeDetailSceneInteractor = knowledgeDetailSceneInteractor
        return self
    }

    func build() -> KnowledgeDetailModuleProviding {
        return KnowledgeDetailModule(knowledgeDetailSceneFactory: knowledgeDetailSceneFactory,
                                     knowledgeDetailSceneInteractor: knowledgeDetailSceneInteractor)
    }

}
