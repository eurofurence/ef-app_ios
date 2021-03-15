import EurofurenceApplication
import EurofurenceModel

struct VisitsEntryFromKnowledgeListViewModel: KnowledgeGroupsListViewModel {
    
    var entryIdentifier: KnowledgeEntryIdentifier
    
    func setDelegate(_ delegate: KnowledgeGroupsListViewModelDelegate) {
        
    }
    
    func describeContentsOfKnowledgeItem(at index: Int, visitor: KnowledgeGroupsListViewModelVisitor) {
        visitor.visit(entryIdentifier)
    }
    
}
