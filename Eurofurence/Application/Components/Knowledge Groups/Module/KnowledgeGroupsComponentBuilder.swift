import EurofurenceModel

public class KnowledgeGroupsComponentBuilder {

    private let knowledgeGroupsViewModelFactory: KnowledgeGroupsViewModelFactory
    private var knowledgeSceneFactory: KnowledgeListSceneFactory

    public init(knowledgeGroupsViewModelFactory: KnowledgeGroupsViewModelFactory) {
        self.knowledgeGroupsViewModelFactory = knowledgeGroupsViewModelFactory
        knowledgeSceneFactory = StoryboardKnowledgeListSceneFactory()
    }

    @discardableResult
    public func with(_ knowledgeSceneFactory: KnowledgeListSceneFactory) -> Self {
        self.knowledgeSceneFactory = knowledgeSceneFactory
        return self
    }

    public func build() -> KnowledgeGroupsListComponentFactory {
        KnowledgeGroupsListComponentFactoryImpl(
            knowledgeSceneFactory: knowledgeSceneFactory,
            knowledgeGroupsViewModelFactory: knowledgeGroupsViewModelFactory
        )
    }

}
