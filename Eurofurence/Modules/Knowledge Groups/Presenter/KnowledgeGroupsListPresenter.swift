import EurofurenceModel
import Foundation

class KnowledgeGroupsListPresenter: KnowledgeListSceneDelegate, KnowledgeGroupsListViewModelDelegate {

    private let scene: KnowledgeListScene
    private let knowledgeListInteractor: KnowledgeGroupsInteractor
    private let viewModelContentVisitor: KnowledgeVisitor
    private var viewModel: KnowledgeGroupsListViewModel?

    init(scene: KnowledgeListScene,
         knowledgeListInteractor: KnowledgeGroupsInteractor,
         delegate: KnowledgeGroupsListModuleDelegate) {
        self.scene = scene
        self.knowledgeListInteractor = knowledgeListInteractor
        viewModelContentVisitor = KnowledgeVisitor(delegate: delegate)

        scene.setKnowledgeListTitle(.information)
        scene.setKnowledgeListShortTitle(.information)
    }

    func knowledgeListSceneDidLoad() {
        scene.showLoadingIndicator()
        knowledgeListInteractor.prepareViewModel(completionHandler: viewModelPrepared)
    }

    func knowledgeListSceneDidSelectKnowledgeGroup(at groupIndex: Int) {
        scene.deselectKnowledgeEntry(at: IndexPath(item: groupIndex, section: 0))
        viewModel?.describeContentsOfKnowledgeItem(at: groupIndex, visitor: viewModelContentVisitor)
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
    
    private struct KnowledgeVisitor: KnowledgeGroupsListViewModelVisitor {
        
        var delegate: KnowledgeGroupsListModuleDelegate
        
        func visit(_ knowledgeGroup: KnowledgeGroupIdentifier) {
            delegate.knowledgeListModuleDidSelectKnowledgeGroup(knowledgeGroup)
        }
        
    }

}
