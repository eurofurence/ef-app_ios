import EurofurenceModel
import Foundation

protocol KnowledgeDetailSceneInteractor {

    func makeViewModel(for identifier: KnowledgeEntryIdentifier, completionHandler: @escaping (KnowledgeEntryDetailViewModel) -> Void)

}
