import Foundation

public protocol ContentLinksService {

    func lookupContent(for link: Link) -> LinkContentLookupResult?
    func setExternalContentHandler(_ externalContentHandler: ExternalContentHandler)

}

public enum LinkContentLookupResult: Equatable {

    case web(URL)
    case externalURL(URL)

}
