import EurofurenceModel
import Foundation

class KnowledgeGroupsListPresenter: KnowledgeListSceneDelegate, KnowledgeGroupsListViewModelDelegate {

    private let scene: KnowledgeListScene
    private let knowledgeGroupsViewModelFactory: KnowledgeGroupsViewModelFactory
    private let viewModelContentVisitor: KnowledgeVisitor
    private var viewModel: KnowledgeGroupsListViewModel?

    init(scene: KnowledgeListScene,
         knowledgeGroupsViewModelFactory: KnowledgeGroupsViewModelFactory,
         delegate: KnowledgeGroupsListComponentDelegate) {
        self.scene = scene
        self.knowledgeGroupsViewModelFactory = knowledgeGroupsViewModelFactory
        viewModelContentVisitor = KnowledgeVisitor(delegate: delegate)
        
        let information = NSLocalizedString(
            "Information",
            bundle: .module,
            comment: "Title for the view showing all the categoried convention information"
        )
        
        scene.setKnowledgeListTitle(information)
        scene.setKnowledgeListShortTitle(information)
    }

    func knowledgeListSceneDidLoad() {
        scene.showLoadingIndicator()
        knowledgeGroupsViewModelFactory.prepareViewModel(completionHandler: viewModelPrepared)
    }

    func knowledgeListSceneDidSelectKnowledgeGroup(at groupIndex: Int) {
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
        
        var delegate: KnowledgeGroupsListComponentDelegate
        
        func visit(_ knowledgeGroup: KnowledgeGroupIdentifier) {
            delegate.knowledgeListModuleDidSelectKnowledgeGroup(knowledgeGroup)
        }
        
        func visit(_ knowledgeEntry: KnowledgeEntryIdentifier) {
            delegate.knowledgeListModuleDidSelectKnowledgeEntry(knowledgeEntry)
        }
        
    }

}
