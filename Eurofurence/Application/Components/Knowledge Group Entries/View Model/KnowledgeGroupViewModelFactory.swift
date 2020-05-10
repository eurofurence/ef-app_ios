import EurofurenceModel
import Foundation

protocol KnowledgeGroupViewModelFactory {

    func makeViewModelForGroup(identifier: KnowledgeGroupIdentifier, completionHandler: @escaping (KnowledgeGroupEntriesViewModel) -> Void)

}
