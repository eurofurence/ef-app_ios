import EurofurenceModel
import Foundation

protocol KnowledgeDetailViewModelFactory {

    func makeViewModel(
        for identifier: KnowledgeEntryIdentifier,
        completionHandler: @escaping (KnowledgeEntryDetailViewModel) -> Void
    )

}
