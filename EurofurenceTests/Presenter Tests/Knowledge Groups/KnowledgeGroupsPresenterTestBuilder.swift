@testable import Eurofurence
import EurofurenceModel
import UIKit.UIViewController

class KnowledgeGroupsPresenterTestBuilder {

    struct Context {
        var knowledgeInteractor: CapturingKnowledgeGroupsInteractor
        var scene: CapturingKnowledgeListScene
        var delegate: CapturingKnowledgeGroupsListModuleDelegate
        var producedViewController: UIViewController
    }

    func build() -> Context {
        let knowledgeInteractor = CapturingKnowledgeGroupsInteractor()
        let sceneFactory = StubKnowledgeListSceneFactory()
        let delegate = CapturingKnowledgeGroupsListModuleDelegate()
        let producedViewController = KnowledgeGroupsModuleBuilder(knowledgeListInteractor: knowledgeInteractor)
            .with(sceneFactory)
            .build()
            .makeKnowledgeListModule(delegate)

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
