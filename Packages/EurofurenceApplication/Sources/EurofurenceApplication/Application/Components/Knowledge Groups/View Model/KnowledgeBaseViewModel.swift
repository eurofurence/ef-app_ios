import EurofurenceModel
import KnowledgeGroupComponent
import UIKit.UIImage

public protocol KnowledgeGroupsListViewModel {

    func setDelegate(_ delegate: KnowledgeGroupsListViewModelDelegate)
    func describeContentsOfKnowledgeItem(at index: Int, visitor: KnowledgeGroupsListViewModelVisitor)

}

public protocol KnowledgeGroupsListViewModelVisitor {
    
    func visit(_ knowledgeGroup: KnowledgeGroupIdentifier)
    func visit(_ knowledgeEntry: KnowledgeEntryIdentifier)
    
}

public protocol KnowledgeGroupsListViewModelDelegate {

    func knowledgeGroupsViewModelsDidUpdate(to viewModels: [KnowledgeListGroupViewModel])

}

public struct KnowledgeListGroupViewModel: Equatable {

    public var title: String
    public var fontAwesomeCharacter: Character
    public var groupDescription: String
//    public var knowledgeEntries: [KnowledgeListEntryViewModel]
    
    public init(
        title: String,
        fontAwesomeCharacter: Character,
        groupDescription: String
//        knowledgeEntries: [KnowledgeListEntryViewModel]
    ) {
        self.title = title
        self.fontAwesomeCharacter = fontAwesomeCharacter
        self.groupDescription = groupDescription
//        self.knowledgeEntries = knowledgeEntries
    }

}
