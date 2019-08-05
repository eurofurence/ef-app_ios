import EurofurenceModel
import UIKit.UIImage

protocol KnowledgeGroupsListViewModel {

    func setDelegate(_ delegate: KnowledgeGroupsListViewModelDelegate)
    func describeContentsOfKnowledgeItem(at index: Int, visitor: KnowledgeGroupsListViewModelVisitor)

}

protocol KnowledgeGroupsListViewModelVisitor {
    
    func visit(_ knowledgeGroup: KnowledgeGroupIdentifier)
    func visit(_ knowledgeEntry: KnowledgeEntryIdentifier)
    
}

protocol KnowledgeGroupsListViewModelDelegate {

    func knowledgeGroupsViewModelsDidUpdate(to viewModels: [KnowledgeListGroupViewModel])

}

struct KnowledgeListGroupViewModel: Equatable {

    var title: String
    var fontAwesomeCharacter: Character
    var groupDescription: String
    var knowledgeEntries: [KnowledgeListEntryViewModel]

}

struct KnowledgeListEntryViewModel: Equatable {

    var title: String

}
