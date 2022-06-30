import Foundation

public struct DefaultCollectThemAllRequestFactory: CollectThemAllRequestFactory {
    
    private let conventionIdentifier: ConventionIdentifier

    public init(conventionIdentifier: ConventionIdentifier) {
        self.conventionIdentifier = conventionIdentifier
    }

    public func makeAnonymousGameURLRequest() -> URLRequest {
        return URLRequest(url: makeGameURL())
    }

    public func makeAuthenticatedGameURLRequest(credential: Credential) -> URLRequest {
        return URLRequest(url: makeGameURL(token: credential.authenticationToken))
    }

    private func makeGameURL(token: String? = nil) -> URL {
        let cid = conventionIdentifier.identifier
        var urlString = "https://app.eurofurence.org/\(cid)/companion/#/login?embedded=true&returnPath=/collect&token="
        
        let tokenToSend: String = {
            if let token = token {
                return token
            } else {
                return "empty"
            }
        }()
        
        urlString.append(tokenToSend)
        
        guard let url = URL(string: urlString) else {
            fatalError("Error marshalling token into url: \(urlString)")
        }
        
        return url
    }

}
