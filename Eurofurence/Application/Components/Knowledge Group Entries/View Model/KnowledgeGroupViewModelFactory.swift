import EurofurenceModel
import Foundation

public protocol KnowledgeGroupViewModelFactory {

    func makeViewModelForGroup(
        identifier: KnowledgeGroupIdentifier,
        completionHandler: @escaping (KnowledgeGroupEntriesViewModel) -> Void
    )

}
