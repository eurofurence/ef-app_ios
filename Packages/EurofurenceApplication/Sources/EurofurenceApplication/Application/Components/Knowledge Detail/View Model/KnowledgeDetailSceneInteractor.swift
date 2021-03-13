import EurofurenceModel
import Foundation

public protocol KnowledgeDetailViewModelFactory {

    func makeViewModel(
        for identifier: KnowledgeEntryIdentifier,
        completionHandler: @escaping (KnowledgeEntryDetailViewModel) -> Void
    )

}
