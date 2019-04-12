@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation
import TestUtilities

struct StubKnowledgeGroupEntriesViewModel: KnowledgeGroupEntriesViewModel {

    var title: String

    var numberOfEntries: Int {
        return entries.count
    }

    func knowledgeEntry(at index: Int) -> KnowledgeListEntryViewModel {
        return entries[index]
    }

    func identifierForKnowledgeEntry(at index: Int) -> KnowledgeEntryIdentifier {
        return KnowledgeEntryIdentifier("\(index) - \(entries[index].title)")
    }

    var entries: [KnowledgeListEntryViewModel]

}

extension StubKnowledgeGroupEntriesViewModel: RandomValueProviding {

    static var random: StubKnowledgeGroupEntriesViewModel {
        return StubKnowledgeGroupEntriesViewModel(title: .random, entries: .random)
    }

}
