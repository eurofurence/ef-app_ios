@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class KnowledgeDetailPresenterTestBuilder {

    struct Context {
        var knowledgeEntryIdentifier: KnowledgeEntryIdentifier
        var knowledgeDetailScene: CapturingKnowledgeDetailScene
        var viewModelFactory: StubKnowledgeDetailViewModelFactory
        var module: UIViewController
        var delegate: CapturingKnowledgeDetailComponentDelegate
    }

    private var viewModelFactory = StubKnowledgeDetailViewModelFactory()

    @discardableResult
    func with(_ viewModelFactory: StubKnowledgeDetailViewModelFactory) -> KnowledgeDetailPresenterTestBuilder {
        self.viewModelFactory = viewModelFactory
        return self
    }

    func build() -> Context {
        let knowledgeEntryIdentifier = KnowledgeEntryIdentifier.random
        let knowledgeDetailSceneFactory = StubKnowledgeDetailSceneFactory()
        let knowledgeDetailScene = knowledgeDetailSceneFactory.interface
        let delegate = CapturingKnowledgeDetailComponentDelegate()
        let moduleBuilder = KnowledgeDetailComponentBuilder(knowledgeDetailViewModelFactory: viewModelFactory)
            .with(knowledgeDetailSceneFactory)
            .build()
        let module = moduleBuilder.makeKnowledgeListComponent(knowledgeEntryIdentifier, delegate: delegate)

        return Context(knowledgeEntryIdentifier: knowledgeEntryIdentifier,
                       knowledgeDetailScene: knowledgeDetailScene,
                       viewModelFactory: viewModelFactory,
                       module: module,
                       delegate: delegate)
    }

}
