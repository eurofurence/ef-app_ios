import EurofurenceModel
import Foundation

public protocol KnowledgeGroupEntriesViewModel {

    var title: String { get }
    var numberOfEntries: Int { get }

    func knowledgeEntry(at index: Int) -> KnowledgeListEntryViewModel
    func identifierForKnowledgeEntry(at index: Int) -> KnowledgeEntryIdentifier

}
