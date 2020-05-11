import Eurofurence
import EurofurenceModel
import UIKit.UIViewController

class KnowledgeGroupsPresenterTestBuilder {

    struct Context {
        var knowledgeViewModelFactory: CapturingKnowledgeGroupsViewModelFactory
        var scene: CapturingKnowledgeListScene
        var delegate: CapturingKnowledgeGroupsListComponentDelegate
        var producedViewController: UIViewController
    }

    func build() -> Context {
        let knowledgeViewModelFactory = CapturingKnowledgeGroupsViewModelFactory()
        let sceneFactory = StubKnowledgeListSceneFactory()
        let delegate = CapturingKnowledgeGroupsListComponentDelegate()
        let producedViewController = KnowledgeGroupsComponentBuilder(knowledgeGroupsViewModelFactory: knowledgeViewModelFactory)
            .with(sceneFactory)
            .build()
            .makeKnowledgeListComponent(delegate)

        return Context(knowledgeViewModelFactory: knowledgeViewModelFactory,
                       scene: sceneFactory.scene,
                       delegate: delegate,
                       producedViewController: producedViewController)
    }

}

extension KnowledgeGroupsPresenterTestBuilder.Context {

    func simulateLoadingViewModel(_ viewModel: KnowledgeGroupsListViewModel = StubKnowledgeGroupsListViewModel.random) {
        knowledgeViewModelFactory.simulateViewModelPrepared(viewModel)
    }

}
