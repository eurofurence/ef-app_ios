import EurofurenceModel

class KnowledgeGroupsModuleBuilder {

    private let knowledgeListInteractor: KnowledgeGroupsInteractor
    private var knowledgeSceneFactory: KnowledgeListSceneFactory

    init(knowledgeListInteractor: KnowledgeGroupsInteractor) {
        self.knowledgeListInteractor = knowledgeListInteractor
        knowledgeSceneFactory = StoryboardKnowledgeListSceneFactory()
    }

    @discardableResult
    func with(_ knowledgeSceneFactory: KnowledgeListSceneFactory) -> KnowledgeGroupsModuleBuilder {
        self.knowledgeSceneFactory = knowledgeSceneFactory
        return self
    }

    func build() -> KnowledgeGroupsListModuleProviding {
        return KnowledgeListModule(knowledgeSceneFactory: knowledgeSceneFactory,
                                   knowledgeListInteractor: knowledgeListInteractor)
    }

}
