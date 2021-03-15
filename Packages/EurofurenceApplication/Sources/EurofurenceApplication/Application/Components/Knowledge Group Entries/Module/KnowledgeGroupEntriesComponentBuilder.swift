import Foundation

public class KnowledgeGroupEntriesComponentBuilder {

    private let knowledgeGroupViewModelFactory: KnowledgeGroupViewModelFactory
    private var sceneFactory: KnowledgeGroupEntriesSceneFactory

    public init(knowledgeGroupViewModelFactory: KnowledgeGroupViewModelFactory) {
        self.knowledgeGroupViewModelFactory = knowledgeGroupViewModelFactory
        sceneFactory = StoryboardKnowledgeGroupEntriesSceneFactory()
    }

    @discardableResult
    public func with(_ sceneFactory: KnowledgeGroupEntriesSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }

    public func build() -> KnowledgeGroupEntriesComponentFactory {
        KnowledgeGroupEntriesComponentFactoryImpl(
            knowledgeGroupViewModelFactory: knowledgeGroupViewModelFactory,
            sceneFactory: sceneFactory
        )
    }

}
