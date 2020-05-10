@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class KnowledgeDetailPresenterTestBuilder {

    struct Context {
        var knowledgeEntryIdentifier: KnowledgeEntryIdentifier
        var knowledgeDetailScene: CapturingKnowledgeDetailScene
        var interactor: StubKnowledgeDetailViewModelFactory
        var module: UIViewController
        var delegate: CapturingKnowledgeDetailComponentDelegate
    }

    private var interactor = StubKnowledgeDetailViewModelFactory()

    @discardableResult
    func with(_ interactor: StubKnowledgeDetailViewModelFactory) -> KnowledgeDetailPresenterTestBuilder {
        self.interactor = interactor
        return self
    }

    func build() -> Context {
        let knowledgeEntryIdentifier = KnowledgeEntryIdentifier.random
        let knowledgeDetailSceneFactory = StubKnowledgeDetailSceneFactory()
        let knowledgeDetailScene = knowledgeDetailSceneFactory.interface
        let delegate = CapturingKnowledgeDetailComponentDelegate()
        let moduleBuilder = KnowledgeDetailComponentBuilder(knowledgeDetailViewModelFactory: interactor)
            .with(knowledgeDetailSceneFactory)
            .build()
        let module = moduleBuilder.makeKnowledgeListModule(knowledgeEntryIdentifier, delegate: delegate)

        return Context(knowledgeEntryIdentifier: knowledgeEntryIdentifier,
                       knowledgeDetailScene: knowledgeDetailScene,
                       interactor: interactor,
                       module: module,
                       delegate: delegate)
    }

}
