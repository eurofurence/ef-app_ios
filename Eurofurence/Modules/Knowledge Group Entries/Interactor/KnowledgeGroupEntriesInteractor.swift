import EurofurenceModel
import Foundation

protocol KnowledgeGroupEntriesInteractor {

    func makeViewModelForGroup(identifier: KnowledgeGroupIdentifier, completionHandler: @escaping (KnowledgeGroupEntriesViewModel) -> Void)

}
