import EurofurenceModel
import KnowledgeGroupComponent
import UIKit.UIImage

public struct DefaultKnowledgeGroupsViewModelFactory: KnowledgeGroupsViewModelFactory {

    private class ViewModel: KnowledgeGroupsListViewModel, KnowledgeServiceObserver {

        private var groups = [KnowledgeGroup]()
        private var knowledgeGroups: [KnowledgeListGroupViewModel] = []
        private var delegate: KnowledgeGroupsListViewModelDelegate?

        func knowledgeGroupsDidChange(to groups: [KnowledgeGroup]) {
            self.groups = groups
            knowledgeGroups = groups.map { (group) -> KnowledgeListGroupViewModel in
                KnowledgeListGroupViewModel(
                    title: group.title,
                    fontAwesomeCharacter: group.fontAwesomeCharacterAddress,
                    groupDescription: group.groupDescription
                )
            }

            delegate?.knowledgeGroupsViewModelsDidUpdate(to: knowledgeGroups)
        }

        func setDelegate(_ delegate: KnowledgeGroupsListViewModelDelegate) {
            self.delegate = delegate
            delegate.knowledgeGroupsViewModelsDidUpdate(to: knowledgeGroups)
        }

        func describeContentsOfKnowledgeItem(at index: Int, visitor: KnowledgeGroupsListViewModelVisitor) {
            let group = groups[index]
            if group.entries.count == 1 {
                let entry = group.entries[0]
                visitor.visit(entry.identifier)
            } else {
                visitor.visit(group.identifier)
            }
        }

    }

    private let service: KnowledgeService

    public init(service: KnowledgeService) {
        self.service = service
    }

    public func prepareViewModel(completionHandler: @escaping (KnowledgeGroupsListViewModel) -> Void) {
        let viewModel = ViewModel()
        service.add(viewModel)
        completionHandler(viewModel)
    }

}
