import Foundation

class KnowledgeDetailModuleBuilder {

    private var knowledgeDetailSceneFactory: KnowledgeDetailSceneFactory
    private let knowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor

    init(knowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor) {
        self.knowledgeDetailSceneInteractor = knowledgeDetailSceneInteractor
        knowledgeDetailSceneFactory = StoryboardKnowledgeDetailSceneFactory()
    }

    @discardableResult
    func with(_ knowledgeDetailSceneFactory: KnowledgeDetailSceneFactory) -> KnowledgeDetailModuleBuilder {
        self.knowledgeDetailSceneFactory = knowledgeDetailSceneFactory
        return self
    }

    func build() -> KnowledgeDetailModuleProviding {
        return KnowledgeDetailModule(knowledgeDetailSceneFactory: knowledgeDetailSceneFactory,
                                     knowledgeDetailSceneInteractor: knowledgeDetailSceneInteractor)
    }

}
