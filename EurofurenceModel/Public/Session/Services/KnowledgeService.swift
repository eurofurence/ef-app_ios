import Foundation

public protocol KnowledgeService {

    func add(_ observer: KnowledgeServiceObserver)

    func fetchKnowledgeEntry(for identifier: KnowledgeEntryIdentifier, completionHandler: @escaping (KnowledgeEntry) -> Void)
    func fetchKnowledgeGroup(identifier: KnowledgeGroupIdentifier, completionHandler: @escaping (KnowledgeGroup) -> Void)
    func fetchImagesForKnowledgeEntry(identifier: KnowledgeEntryIdentifier, completionHandler: @escaping ([Data]) -> Void)

}

public protocol KnowledgeServiceObserver {

    func knowledgeGroupsDidChange(to groups: [KnowledgeGroup])

}
