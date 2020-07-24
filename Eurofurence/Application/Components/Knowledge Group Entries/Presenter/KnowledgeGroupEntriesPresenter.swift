import EurofurenceModel
import Foundation

class KnowledgeGroupEntriesPresenter: KnowledgeGroupEntriesSceneDelegate {

    private struct Binder: KnowledgeGroupEntriesBinder {

        var viewModel: KnowledgeGroupEntriesViewModel

        func bind(_ component: KnowledgeGroupEntryScene, at index: Int) {
            let entryViewModel = viewModel.knowledgeEntry(at: index)
            component.setKnowledgeEntryTitle(entryViewModel.title)
        }

    }

    private weak var scene: KnowledgeGroupEntriesScene?
    private let knowledgeGroupViewModelFactory: KnowledgeGroupViewModelFactory
    private let groupIdentifier: KnowledgeGroupIdentifier
    private let delegate: KnowledgeGroupEntriesComponentDelegate
    private var viewModel: KnowledgeGroupEntriesViewModel?

    init(scene: KnowledgeGroupEntriesScene,
         knowledgeGroupViewModelFactory: KnowledgeGroupViewModelFactory,
         groupIdentifier: KnowledgeGroupIdentifier,
         delegate: KnowledgeGroupEntriesComponentDelegate) {
        self.scene = scene
        self.knowledgeGroupViewModelFactory = knowledgeGroupViewModelFactory
        self.groupIdentifier = groupIdentifier
        self.delegate = delegate

        scene.setDelegate(self)
    }

    func knowledgeGroupEntriesSceneDidLoad() {
        knowledgeGroupViewModelFactory.makeViewModelForGroup(
            identifier: groupIdentifier,
            completionHandler: viewModelReady
        )
    }

    func knowledgeGroupEntriesSceneDidSelectEntry(at index: Int) {
        guard let identifier = viewModel?.identifierForKnowledgeEntry(at: index) else { return }
        delegate.knowledgeGroupEntriesComponentDidSelectKnowledgeEntry(identifier: identifier)
    }

    private func viewModelReady(_ viewModel: KnowledgeGroupEntriesViewModel) {
        self.viewModel = viewModel
        scene?.setKnowledgeGroupTitle(viewModel.title)
        scene?.bind(numberOfEntries: viewModel.numberOfEntries, using: Binder(viewModel: viewModel))
    }

}
