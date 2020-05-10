@testable import Eurofurence
import EurofurenceModel
import UIKit.UIViewController

class KnowledgeGroupsPresenterTestBuilder {

    struct Context {
        var knowledgeInteractor: CapturingKnowledgeGroupsViewModelFactory
        var scene: CapturingKnowledgeListScene
        var delegate: CapturingKnowledgeGroupsListComponentDelegate
        var producedViewController: UIViewController
    }

    func build() -> Context {
        let knowledgeInteractor = CapturingKnowledgeGroupsViewModelFactory()
        let sceneFactory = StubKnowledgeListSceneFactory()
        let delegate = CapturingKnowledgeGroupsListComponentDelegate()
        let producedViewController = KnowledgeGroupsComponentBuilder(knowledgeListInteractor: knowledgeInteractor)
            .with(sceneFactory)
            .build()
            .makeKnowledgeListComponent(delegate)

        return Context(knowledgeInteractor: knowledgeInteractor,
                       scene: sceneFactory.scene,
                       delegate: delegate,
                       producedViewController: producedViewController)
    }

}

extension KnowledgeGroupsPresenterTestBuilder.Context {

    func simulateLoadingViewModel(_ viewModel: KnowledgeGroupsListViewModel = StubKnowledgeGroupsListViewModel.random) {
        knowledgeInteractor.simulateViewModelPrepared(viewModel)
    }

}
