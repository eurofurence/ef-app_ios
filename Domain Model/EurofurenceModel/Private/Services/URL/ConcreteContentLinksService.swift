import Foundation

class ConcreteContentLinksService: ContentLinksService {

    private let urlEntityProcessor: URLEntityProcessor

    init(urlEntityProcessor: URLEntityProcessor) {
        self.urlEntityProcessor = urlEntityProcessor
    }

    func lookupContent(for link: Link) -> LinkContentLookupResult? {
        guard let urlString = link.contents as? String, let url = URL(string: urlString) else { return nil }

        if let scheme = url.scheme, scheme == "https" || scheme == "http" {
            return .web(url)
        }

        return .externalURL(url)
    }
    
    func describeContent(in url: URL, toVisitor visitor: URLContentVisitor) {
        urlEntityProcessor.process(url, visitor: visitor)
    }

}
