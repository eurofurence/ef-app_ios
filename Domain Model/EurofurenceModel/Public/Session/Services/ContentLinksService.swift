import Foundation

public enum URLContent {
    case event(EventIdentifier)
}

public protocol ContentLinksService {

    func lookupContent(for link: Link) -> LinkContentLookupResult?
    func describeContent(in url: URL, toVisitor visitor: URLContentVisitor)

}

public protocol URLContentVisitor {
    
    func visit(_ event: EventIdentifier)
    
    func visit(_ dealer: DealerIdentifier)
    
    func visitKnowledgeGroups()
    
    func visitKnowledgeEntry(_ knowledgeEntry: KnowledgeEntryIdentifier)
    
    func visitKnowledgeEntry(
        _ knowledgeEntry: KnowledgeEntryIdentifier,
        containedWithinGroup knowledgeGroup: KnowledgeGroupIdentifier
    )
    
}

public enum LinkContentLookupResult: Equatable {

    case web(URL)
    case externalURL(URL)

}
