import EurofurenceModel
import Foundation

struct DefaultKnowledgeGroupEntriesInteractor: KnowledgeGroupEntriesInteractor {

    private struct ViewModel: KnowledgeGroupEntriesViewModel {

        var title: String
        var entries: [KnowledgeEntry]

        var numberOfEntries: Int { return entries.count }

        func knowledgeEntry(at index: Int) -> KnowledgeListEntryViewModel {
            let entry = entries[index]
            return KnowledgeListEntryViewModel(title: entry.title)
        }

        func identifierForKnowledgeEntry(at index: Int) -> KnowledgeEntryIdentifier {
            return entries[index].identifier
        }

    }

    var service: KnowledgeService = ApplicationStack.instance.services.knowledge

    func makeViewModelForGroup(identifier: KnowledgeGroupIdentifier, completionHandler: @escaping (KnowledgeGroupEntriesViewModel) -> Void) {
        service.fetchKnowledgeGroup(identifier: identifier) { (group) in
            let viewModel = ViewModel(title: group.title, entries: group.entries)
            completionHandler(viewModel)
        }
    }

}
