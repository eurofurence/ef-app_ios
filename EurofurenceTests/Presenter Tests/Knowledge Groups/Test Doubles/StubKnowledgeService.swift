import EurofurenceModel
import Foundation

class StubKnowledgeService: KnowledgeService {

    func fetchKnowledgeGroup(identifier: KnowledgeGroupIdentifier, completionHandler: @escaping (KnowledgeGroup) -> Void) {

    }

    fileprivate var observers: [KnowledgeServiceObserver] = []
    func add(_ observer: KnowledgeServiceObserver) {
        observers.append(observer)
    }

    func fetchKnowledgeEntry(for identifier: KnowledgeEntryIdentifier, completionHandler: @escaping (KnowledgeEntry) -> Void) {

    }

    func fetchKnowledgeGroup(identifier: KnowledgeGroupIdentifier, completionHandler: @escaping ([KnowledgeEntry]) -> Void) {

    }

    func fetchImagesForKnowledgeEntry(identifier: KnowledgeEntryIdentifier, completionHandler: @escaping ([Data]) -> Void) {

    }

}

extension StubKnowledgeService {

    func simulateFetchSucceeded(_ models: [KnowledgeGroup]) {
        observers.forEach { $0.knowledgeGroupsDidChange(to: models) }
    }

}
