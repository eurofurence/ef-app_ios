import EurofurenceModel

class KnowledgeGroupsComponentBuilder {

    private let knowledgeGroupsViewModelFactory: KnowledgeGroupsViewModelFactory
    private var knowledgeSceneFactory: KnowledgeListSceneFactory

    init(knowledgeGroupsViewModelFactory: KnowledgeGroupsViewModelFactory) {
        self.knowledgeGroupsViewModelFactory = knowledgeGroupsViewModelFactory
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
            knowledgeGroupsViewModelFactory: knowledgeGroupsViewModelFactory
        )
    }

}
