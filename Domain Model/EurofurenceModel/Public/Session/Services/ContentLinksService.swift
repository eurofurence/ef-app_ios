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
    
}

public enum LinkContentLookupResult: Equatable {

    case web(URL)
    case externalURL(URL)

}
