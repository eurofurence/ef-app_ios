import EurofurenceModel
import Foundation

public class FakeKnowledgeService: KnowledgeService {
    
    public init() {
        
    }

    public func add(_ observer: KnowledgeServiceObserver) {

    }

    private var stubbedKnowledgeEntries = [KnowledgeEntryIdentifier: FakeKnowledgeEntry]()
    public func fetchKnowledgeEntry(
        for identifier: KnowledgeEntryIdentifier,
        completionHandler: @escaping (KnowledgeEntry) -> Void
    ) {
        completionHandler(stubbedKnowledgeEntry(for: identifier))
    }

    public func fetchImagesForKnowledgeEntry(
        identifier: KnowledgeEntryIdentifier,
        completionHandler: @escaping ([Data]) -> Void
    ) {
        completionHandler(stubbedKnowledgeEntryImages(for: identifier))
    }

    private var stubbedGroups = [KnowledgeGroup]()
    public func fetchKnowledgeGroup(
        identifier: KnowledgeGroupIdentifier,
        completionHandler: @escaping (KnowledgeGroup) -> Void
    ) {
        stubbedGroups.first(where: { $0.identifier == identifier }).let(completionHandler)
    }

}

extension FakeKnowledgeService {

    public func stubbedKnowledgeEntry(for identifier: KnowledgeEntryIdentifier) -> FakeKnowledgeEntry {
        if let entry = stubbedKnowledgeEntries[identifier] {
            return entry
        }

        let randomEntry = FakeKnowledgeEntry.random
        stub(randomEntry)

        return randomEntry
    }
    
    public func stub(_ entry: FakeKnowledgeEntry) {
        stubbedKnowledgeEntries[entry.identifier] = entry
    }

    public func stub(_ group: KnowledgeGroup) {
        stubbedGroups.append(group)
    }

    public func stubbedKnowledgeEntryImages(for identifier: KnowledgeEntryIdentifier) -> [Data] {
        return [identifier.rawValue.data(using: .utf8).unsafelyUnwrapped]
    }

}
