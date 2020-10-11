import EurofurenceModel
import Foundation

public class StubKnowledgeService: KnowledgeService {
    
    public init() {
        
    }

    public func fetchKnowledgeGroup(
        identifier: KnowledgeGroupIdentifier,
        completionHandler: @escaping (KnowledgeGroup) -> Void
    ) {

    }

    fileprivate var observers: [KnowledgeServiceObserver] = []
    public func add(_ observer: KnowledgeServiceObserver) {
        observers.append(observer)
    }

    public func fetchKnowledgeEntry(
        for identifier: KnowledgeEntryIdentifier,
        completionHandler: @escaping (KnowledgeEntry) -> Void
    ) {

    }

    public func fetchKnowledgeGroup(
        identifier: KnowledgeGroupIdentifier,
        completionHandler: @escaping ([KnowledgeEntry]) -> Void
    ) {

    }

    public func fetchImagesForKnowledgeEntry(
        identifier: KnowledgeEntryIdentifier,
        completionHandler: @escaping ([Data]) -> Void
    ) {

    }

}

extension StubKnowledgeService {

    public func simulateFetchSucceeded(_ models: [KnowledgeGroup]) {
        observers.forEach { $0.knowledgeGroupsDidChange(to: models) }
    }

}
