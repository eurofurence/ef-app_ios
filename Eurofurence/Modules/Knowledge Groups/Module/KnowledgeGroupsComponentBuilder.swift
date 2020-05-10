import EurofurenceModel

class KnowledgeGroupsComponentBuilder {

    private let knowledgeListInteractor: KnowledgeGroupsViewModelFactory
    private var knowledgeSceneFactory: KnowledgeListSceneFactory

    init(knowledgeListInteractor: KnowledgeGroupsViewModelFactory) {
        self.knowledgeListInteractor = knowledgeListInteractor
        knowledgeSceneFactory = StoryboardKnowledgeListSceneFactory()
    }

    @discardableResult
    func with(_ knowledgeSceneFactory: KnowledgeListSceneFactory) -> Self {
        self.knowledgeSceneFactory = knowledgeSceneFactory
        return self
    }

    func build() -> KnowledgeGroupsListComponentFactory {
        KnowledgeGroupsListComponentFactoryImpl(
            knowledgeSceneFactory: knowledgeSceneFactory,
            knowledgeListInteractor: knowledgeListInteractor
        )
    }

}
