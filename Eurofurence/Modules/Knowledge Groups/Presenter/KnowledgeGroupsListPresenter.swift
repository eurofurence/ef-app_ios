import Foundation.NSIndexPath

class KnowledgeGroupsListPresenter: KnowledgeListSceneDelegate, KnowledgeGroupsListViewModelDelegate {

    private let scene: KnowledgeListScene
    private let knowledgeListInteractor: KnowledgeGroupsInteractor
    private let delegate: KnowledgeGroupsListModuleDelegate
    private var viewModel: KnowledgeGroupsListViewModel?

    init(scene: KnowledgeListScene,
         knowledgeListInteractor: KnowledgeGroupsInteractor,
         delegate: KnowledgeGroupsListModuleDelegate) {
        self.scene = scene
        self.knowledgeListInteractor = knowledgeListInteractor
        self.delegate = delegate

        scene.setKnowledgeListTitle(.information)
        scene.setKnowledgeListShortTitle(.information)
    }

    func knowledgeListSceneDidLoad() {
        scene.showLoadingIndicator()
        knowledgeListInteractor.prepareViewModel(completionHandler: viewModelPrepared)
    }

    func knowledgeListSceneDidSelectKnowledgeGroup(at groupIndex: Int) {
        scene.deselectKnowledgeEntry(at: IndexPath(item: groupIndex, section: 0))
        viewModel?.fetchIdentifierForGroup(at: groupIndex, completionHandler: delegate.knowledgeListModuleDidSelectKnowledgeGroup)
    }

    func knowledgeGroupsViewModelsDidUpdate(to viewModels: [KnowledgeListGroupViewModel]) {
        let binder = ListBinder(viewModels: viewModels)
        scene.prepareToDisplayKnowledgeGroups(numberOfGroups: viewModels.count, binder: binder)
    }

    private func viewModelPrepared(_ viewModel: KnowledgeGroupsListViewModel) {
        self.viewModel = viewModel
        viewModel.setDelegate(self)
        scene.hideLoadingIndicator()
    }

    private struct ListBinder: KnowledgeListBinder {

        var viewModels: [KnowledgeListGroupViewModel]

        func bind(_ header: KnowledgeGroupScene, toGroupAt index: Int) {
            let group = viewModels[index]

            header.setKnowledgeGroupTitle(group.title)
            header.setKnowledgeGroupFontAwesomeCharacter(group.fontAwesomeCharacter)
            header.setKnowledgeGroupDescription(group.groupDescription)
        }

    }

}
