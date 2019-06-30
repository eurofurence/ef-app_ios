import Foundation

public enum URLContent {
    case event(EventIdentifier)
}

public protocol ContentLinksService {

    func lookupContent(for link: Link) -> LinkContentLookupResult?
    func setExternalContentHandler(_ externalContentHandler: ExternalContentHandler)
    func describeContent(in url: URL, toVisitor visitor: URLContentVisitor)

}

public protocol URLContentVisitor {
    
    func visit(_ event: EventIdentifier)
    
}

public enum LinkContentLookupResult: Equatable {

    case web(URL)
    case externalURL(URL)

}
