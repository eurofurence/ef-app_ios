@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation
import TestUtilities

struct StubKnowledgeGroupsListViewModel: KnowledgeGroupsListViewModel {

    var knowledgeGroups: [KnowledgeListGroupViewModel] = []

    func setDelegate(_ delegate: KnowledgeGroupsListViewModelDelegate) {
        delegate.knowledgeGroupsViewModelsDidUpdate(to: knowledgeGroups)
    }

    func fetchIdentifierForGroup(at index: Int, completionHandler: @escaping (KnowledgeGroupIdentifier) -> Void) {
        completionHandler(stubbedGroupIdentifier(at: index))
    }

}

extension StubKnowledgeGroupsListViewModel: RandomValueProviding {

    static var random: StubKnowledgeGroupsListViewModel {
        return StubKnowledgeGroupsListViewModel(knowledgeGroups: .random)
    }

    func stubbedGroupIdentifier(at index: Int) -> KnowledgeGroupIdentifier {
        return KnowledgeGroupIdentifier("\(index)")
    }

}
