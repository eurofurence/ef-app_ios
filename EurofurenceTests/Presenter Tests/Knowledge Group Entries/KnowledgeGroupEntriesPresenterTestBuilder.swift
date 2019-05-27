@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation
import UIKit

class KnowledgeGroupEntriesPresenterTestBuilder {

    struct Context {
        var viewController: UIViewController
        var viewModel: StubKnowledgeGroupEntriesViewModel
        var sceneFactory: StubKnowledgeGroupEntriesSceneFactory
        var delegate: CapturingKnowledgeGroupEntriesModuleDelegate
    }

    func build() -> Context {
        let viewModel = StubKnowledgeGroupEntriesViewModel.random
        let groupIdentifier = KnowledgeGroupIdentifier.random
        let interactor = FakeKnowledgeGroupEntriesInteractor(for: groupIdentifier, viewModel: viewModel)
        let sceneFactory = StubKnowledgeGroupEntriesSceneFactory()
        let delegate = CapturingKnowledgeGroupEntriesModuleDelegate()
        let module = KnowledgeGroupEntriesModuleBuilder(interactor: interactor)
            .with(sceneFactory)
            .build()
            .makeKnowledgeGroupEntriesModule(groupIdentifier, delegate: delegate)

        return Context(viewController: module,
                       viewModel: viewModel,
                       sceneFactory: sceneFactory,
                       delegate: delegate)
    }

}

extension KnowledgeGroupEntriesPresenterTestBuilder.Context {

    func simulateSceneDidLoad() {
        sceneFactory.scene.simulateSceneDidLoad()
    }

    func simulateSceneDidSelectEntry(at index: Int) {
        sceneFactory.scene.simulateSceneDidSelectEntry(at: index)
    }

    func bind(_ component: CapturingKnowledgeGroupEntryScene, at index: Int) {
        sceneFactory.scene.binder?.bind(component, at: index)
    }

}
