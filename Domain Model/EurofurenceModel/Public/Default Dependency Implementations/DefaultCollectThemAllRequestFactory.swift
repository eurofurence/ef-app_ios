import Foundation

public struct DefaultCollectThemAllRequestFactory: CollectThemAllRequestFactory {

    public init() {
    }

    public func makeAnonymousGameURLRequest() -> URLRequest {
        return URLRequest(url: makeGameURL())
    }

    public func makeAuthenticatedGameURLRequest(credential: Credential) -> URLRequest {
        return URLRequest(url: makeGameURL(token: credential.authenticationToken))
    }

    private func makeGameURL(token: String? = nil) -> URL {
        var urlString = "https://app.eurofurence.org/EF25/companion/#/login?embedded=true&returnPath=/collect"
        if let token = token {
            urlString.append("&token=\(token)")
        }
        
        guard let url = URL(string: urlString) else {
            fatalError("Error marshalling token into url: \(urlString)")
        }
        
        return url
    }

}
